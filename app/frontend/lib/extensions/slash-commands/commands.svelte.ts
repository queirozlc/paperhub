import { Extension } from '@tiptap/core'
import { PluginKey } from '@tiptap/pm/state'
import Suggestion from '@tiptap/suggestion'
import { mount, unmount } from 'svelte'
import tippy from 'tippy.js'
import GROUPS from './groups'
import MenuList from './menu-list.svelte'
import type { MenuListProps } from './types'

let popup: ReturnType<typeof tippy>

const EXTENSION_NAME = 'slash-command'

export const SlashCommands = Extension.create({
  name: EXTENSION_NAME,
  priority: 200,
  onCreate() {
    popup = tippy('body', {
      interactive: true,
      trigger: 'manual',
      placement: 'bottom-start',
      theme: 'slash-command',
      offset: [16, 8],
      popperOptions: {
        strategy: 'fixed',
        modifiers: [
          {
            name: 'flip',
            enabled: false,
          },
        ],
      },
    })
  },
  addProseMirrorPlugins() {
    return [
      Suggestion({
        editor: this.editor,
        char: '/',
        allowSpaces: true,
        startOfLine: true,
        pluginKey: new PluginKey(EXTENSION_NAME),
        allow: ({ state, range }) => {
          const _from = state.doc.resolve(range.from)
          const isRootDepth = _from.depth === 1
          const isParagraph = _from.parent.type.name === 'paragraph'
          const isStartOfNode = _from.parent.textContent?.charAt(0) === '/'
          // TODO
          const isInColumn = this.editor.isActive('column')

          const afterContent = _from.parent.textContent?.substring(
            _from.parent.textContent?.indexOf('/')
          )
          const isValidAfterContent = !afterContent?.endsWith('  ')

          return (
            ((isRootDepth && isParagraph && isStartOfNode) ||
              (isInColumn && isParagraph && isStartOfNode)) &&
            isValidAfterContent
          )
        },
        command: ({ editor, props }) => {
          const { view, state } = editor
          const { $head: _head, $from: _from } = view.state.selection

          const end = _from.pos
          const from = _head?.nodeBefore
            ? end -
              (_head.nodeBefore.text?.substring(
                _head.nodeBefore.text?.indexOf('/')
              ).length ?? 0)
            : _from.start()

          const tr = state.tr.deleteRange(from, end)
          view.dispatch(tr)

          props.action(editor)
          view.focus()
        },
        items: ({ query }: { query: string }) => {
          const withFilteredCommands = GROUPS.map((group) => ({
            ...group,
            commands: group.commands
              .filter((item) => {
                const labelNormalized = item.label
                  .normalize('NFD')
                  .replace(/[^\w\s]/gi, '')
                  .toLowerCase()
                  .trim()
                const queryNormalized = query
                  .normalize('NFD')
                  .replace(/[^\w\s]/gi, '')
                  .toLowerCase()
                  .trim()

                if (item.aliases) {
                  const aliases = item.aliases.map((alias) =>
                    alias.toLowerCase().trim()
                  )

                  return (
                    labelNormalized.includes(queryNormalized) ||
                    aliases.includes(queryNormalized)
                  )
                }

                return labelNormalized.includes(queryNormalized)
              })
              .filter((command) =>
                command.shouldBeHidden
                  ? !command.shouldBeHidden(this.editor)
                  : true
              ),
          }))

          const withoutEmptyGroups = withFilteredCommands.filter((group) => {
            if (group.commands.length > 0) {
              return true
            }

            return false
          })

          const withEnabledSettings = withoutEmptyGroups.map((group) => ({
            ...group,
            commands: group.commands.map((command) => ({
              ...command,
              isEnabled: true,
            })),
          }))

          return withEnabledSettings
        },
        render: () => {
          let component: ReturnType<typeof mount>

          let scrollHandler: (() => void) | null = null

          const componentProps: MenuListProps = $state({
            command: null,
            editor: null,
            items: [],
          })

          const target = document.createElement('div')

          return {
            onStart: (props) => {
              Object.assign(componentProps, props)

              component = mount(MenuList, {
                target,
                props: componentProps,
              })

              popup?.[0].setProps({
                getReferenceClientRect: props.clientRect,
                appendTo: () => document.body,
                content: target,
              })

              popup?.[0].show()
            },

            onUpdate(props) {
              const { view } = props.editor

              Object.assign(componentProps, props)

              const getReferenceClientRect = () => {
                if (!props.clientRect) {
                  return props.editor.storage[EXTENSION_NAME].rect
                }

                const rect = props.clientRect()

                if (!rect) {
                  return props.editor.storage[EXTENSION_NAME].rect
                }

                let yPos = rect.y

                if (rect.top + target.offsetHeight + 40 > window.innerHeight) {
                  const diff =
                    rect.top + target.offsetHeight - window.innerHeight + 40
                  yPos = rect.y - diff
                }

                return new DOMRect(rect.x, yPos, rect.width, rect.height)
              }

              scrollHandler = () => {
                popup?.[0].setProps({
                  getReferenceClientRect,
                })
              }

              view.dom.parentElement?.addEventListener('scroll', scrollHandler)

              props.editor.storage[EXTENSION_NAME].rect = props.clientRect
                ? getReferenceClientRect()
                : {
                    width: 0,
                    height: 0,
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                  }
              popup?.[0].setProps({
                getReferenceClientRect,
              })
            },

            onKeyDown({ event }) {
              if (event.key === 'Escape') {
                popup?.[0].hide()

                return true
              }

              if (!popup?.[0].state.isShown) {
                popup?.[0].show()
              }

              if (event.key === 'Enter') {
                event.preventDefault()
                return true
              }

              if (event.key === 'ArrowUp') {
                event.preventDefault()
                return true
              }
            },

            onExit(props) {
              popup?.[0].hide()
              if (scrollHandler) {
                const { view } = props.editor
                view.dom.parentElement?.removeEventListener(
                  'scroll',
                  scrollHandler
                )
              }
              if (component) {
                unmount(component)
              }
            },
          }
        },
      }),
    ]
  },

  addStorage() {
    return {
      rect: {
        width: 0,
        height: 0,
        left: 0,
        top: 0,
        right: 0,
        bottom: 0,
      },
    }
  },
})

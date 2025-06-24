import { mergeAttributes } from '@tiptap/core'
import TiptapLink from '@tiptap/extension-link'
import { Plugin } from '@tiptap/pm/state'
import { EditorView } from '@tiptap/pm/view'

const unallowedProtocols = ['javascript:', 'vbscript:', 'data:']

export const Link = TiptapLink.extend({
  inclusive: false,

  parseHTML() {
    return [
      {
        tag: 'a[href]:not([data-type="button"]):not([href *= "javascript:" i])',
        getAttrs: (element) => {
          const href = element.getAttribute('href')
          if (
            href &&
            unallowedProtocols.some((protocol) => href.startsWith(protocol))
          ) {
            return false
          }

          return null
        },
      },
    ]
  },

  renderHTML({ HTMLAttributes }) {
    const href = HTMLAttributes.href

    if (
      href &&
      unallowedProtocols.some((protocol) => href.startsWith(protocol))
    ) {
      return [
        'a',
        mergeAttributes(
          this.options.HTMLAttributes,
          { ...HTMLAttributes, href: '' },
          { class: 'link' }
        ),
        0,
      ]
    }

    return [
      'a',
      mergeAttributes(this.options.HTMLAttributes, HTMLAttributes, {
        class: 'link',
      }),
      0,
    ]
  },

  addProseMirrorPlugins() {
    const { editor } = this

    return [
      ...(this.parent?.() || []),
      new Plugin({
        props: {
          handleKeyDown: (_view: EditorView, event: KeyboardEvent) => {
            const { selection } = editor.state

            if (event.key === 'Escape' && selection.empty !== true) {
              editor.commands.focus(selection.to, { scrollIntoView: false })
            }

            return false
          },
        },
      }),
    ]
  },

  addKeyboardShortcuts() {
    return {
      'Mod-Shift-k': ({ editor }) => {
        const { view, state } = editor
        const { from, to } = view.state.selection
        const text = state.doc.textBetween(from, to, '')
        return editor.commands.setLink({
          href: `https://${text}`,
          target: '_blank',
        })
      },
    }
  },
})

export default Link

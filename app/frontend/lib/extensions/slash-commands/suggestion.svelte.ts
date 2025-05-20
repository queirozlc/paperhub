import type { Editor, Range } from '@tiptap/core'
import { mount, unmount } from 'svelte'
import tippy from 'tippy.js'
import Slash from './slash-menu.svelte'

export type Command = {
  title: string
  subtitle: string
  command: ({ editor, range }: { editor: Editor; range: Range }) => void
}

export type Items = (props: { query: string }) => Command[]

export type MenuProps = {
  editor: Editor
  range: Range
  items: Command[]
  clientRect?: () => DOMRect
}

type SlashMenuLifecycle = {
  onStart: (props: MenuProps) => void

  onUpdate: (props: MenuProps) => void

  onKeyDown: (props: { event: KeyboardEvent }) => boolean

  onExit: () => void
}

type SlashSuggestion = {
  items: Items
  render: () => SlashMenuLifecycle
}

export default {
  items: ({ query }) => {
    return [
      {
        title: 'Heading 1',
        subtitle: 'BIG heading',
        command: ({ editor, range }) => {
          editor
            .chain()
            .focus()
            .deleteRange(range)
            .setNode('heading', { level: 1 })
            .run()
        },
      },
      {
        title: 'Heading 2',
        subtitle: 'Less Big heading',
        command: ({ editor, range }) => {
          editor
            .chain()
            .focus()
            .deleteRange(range)
            .setNode('heading', { level: 2 })
            .run()
        },
      },
      {
        title: 'Heading 3',
        subtitle: 'Medium big heading',
        command: ({ editor, range }) => {
          editor
            .chain()
            .focus()
            .deleteRange(range)
            .setNode('heading', { level: 3 })
            .run()
        },
      },
      {
        title: 'To Dos',
        subtitle: 'Create a to do list with checkboxes',
        command: ({ editor, range }) => {
          editor.chain().deleteRange(range).focus().toggleTaskList().run()
        },
      },
    ]
      .filter((item) => {
        return item.title
          .trim()
          .toLowerCase()
          .includes(query.trim().toLowerCase())
      })
      .slice(0, 5)
  },

  render: () => {
    let component: ReturnType<typeof mount>, popup: ReturnType<typeof tippy>
    const props: MenuProps = $state({
      editor: null,
      range: null,
      items: [],
    })

    return {
      onStart: ({ editor, clientRect, range, items }) => {
        const element = document.createElement('div')

        Object.assign(props, { editor, range, items })

        component = mount(Slash, {
          target: element,
          props,
        })

        popup = tippy('body', {
          getReferenceClientRect: clientRect,
          appendTo: () => document.body,
          content: element,
          showOnCreate: true,
          interactive: true,
          trigger: 'manual',
          placement: 'bottom-start',
        })
      },

      onUpdate({ editor, range, items, clientRect }) {
        Object.assign(props, { range, items, editor })

        if (!clientRect) {
          return
        }

        popup[0].setProps({
          getReferenceClientRect: clientRect,
        })
      },

      onKeyDown({ event }) {
        if (event.key === 'Escape') {
          popup[0].hide()
          return true
        }
        if (event.key === 'Enter') {
          event.preventDefault()
          return true
        }
      },

      onExit() {
        if (popup) {
          popup[0].destroy()
          popup = null
        }
        if (component) {
          unmount(component)
          component = null
        }
      },
    }
  },
} as SlashSuggestion

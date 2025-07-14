import { Node, mergeAttributes } from '@tiptap/core'

export interface ChangeOptions {
  HTMLAttributes: Record<string, any>
}

export interface ChangeAttributes {
  'data-action': 'add' | 'remove'
}

declare module '@tiptap/core' {
  interface Commands<ReturnType> {
    change: {
      /**
       * Insere um elemento change
       */
      setChange: (attributes?: ChangeAttributes) => ReturnType
      /**
       * Remove o elemento change
       */
      unsetChange: () => ReturnType
      /**
       * Alterna o elemento change
       */
      toggleChange: (attributes?: ChangeAttributes) => ReturnType
    }
  }
}

export const Change = Node.create<ChangeOptions>({
  name: 'change',

  addOptions() {
    return {
      HTMLAttributes: {},
    }
  },

  group: 'inline',

  content: 'text*',

  inline: true,

  defining: true,

  addAttributes() {
    return {
      'data-action': {
        default: null,
        parseHTML: element => element.getAttribute('data-action'),
        renderHTML: attributes => {
          if (!attributes['data-action']) {
            return {}
          }
          return {
            'data-action': attributes['data-action'],
          }
        },
      },
    }
  },

  parseHTML() {
    return [
      {
        tag: 'span[data-change]',
      },
      {
        tag: 'change'
      }
    ]
  },

  renderHTML({ HTMLAttributes }) {
    return [
      'span',
      mergeAttributes(
        { 'data-change': '' },
        this.options.HTMLAttributes,
        HTMLAttributes
      ),
      0,
    ]
  },

  addCommands() {
    return {
      setChange:
        (attributes) =>
        ({ commands }) => {
          return commands.wrapIn(this.name, attributes)
        },
      unsetChange:
        () =>
        ({ commands }) => {
          return commands.lift(this.name)
        },
      toggleChange:
        (attributes) =>
        ({ commands }) => {
          return commands.toggleWrap(this.name, attributes)
        },
    }
  },

  // addKeyboardShortcuts() {
  //   return {
  //     'Mod-Shift-s': () => this.editor.commands.toggleChange(),
  //   }
  // },
})

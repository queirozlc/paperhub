import { Mark, mergeAttributes } from '@tiptap/core'

declare module '@tiptap/core' {
  interface Commands<ReturnType> {
    diff: {
      /**
       * Insere um elemento diff
       */
      setDiff: () => ReturnType
      /**
       * Remove o elemento diff
       */
      unsetDiff: () => ReturnType
      /**
       * Alterna o elemento diff
       */
      toggleDiff: () => ReturnType
    }
  }
}

export const Diff = Mark.create({
  name: 'diff',

  addOptions() {
    return {
      HTMLAttributes: {},
    }
  },

  addAttributes() {
    return {
      'data-action': {
        default: null,
        parseHTML: (element) => element.getAttribute('data-action'),
        renderHTML: (attributes) => {
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
        tag: 'span[data-diff]',
      },
      {
        tag: 'diff',
      },
    ]
  },

  renderHTML({ HTMLAttributes }) {
    return [
      'span',
      mergeAttributes(
        { 'data-diff': '' },
        this.options.HTMLAttributes,
        HTMLAttributes
      ),
      0,
    ]
  },

  addCommands() {
    return {
      setDiff:
        () =>
        ({ commands }) => {
          return commands.wrapIn(this.name)
        },
      unsetDiff:
        () =>
        ({ commands }) => {
          return commands.lift(this.name)
        },
      toggleDiff:
        () =>
        ({ commands }) => {
          return commands.toggleWrap(this.name)
        },
    }
  },
})

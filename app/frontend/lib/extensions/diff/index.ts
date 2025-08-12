import { Mark, mergeAttributes } from '@tiptap/core'

export interface DiffOptions {
  HTMLAttributes: Record<string, any>
}

export interface DiffAttributes {
  //'data-action': 'add' | 'remove'
}

declare module '@tiptap/core' {
  interface Commands<ReturnType> {
    diff: {
      /**
       * Insere um elemento diff
       */
      setDiff: (attributes?: DiffAttributes) => ReturnType
      /**
       * Remove o elemento diff
       */
      unsetDiff: () => ReturnType
      /**
       * Alterna o elemento diff
       */
      toggleDiff: (attributes?: DiffAttributes) => ReturnType
    }
  }
}

export const Diff = Mark.create<DiffOptions>({
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
        (attributes) =>
        ({ commands }) => {
          return commands.wrapIn(this.name, attributes)
        },
      unsetDiff:
        () =>
        ({ commands }) => {
          return commands.lift(this.name)
        },
      toggleDiff:
        (attributes) =>
        ({ commands }) => {
          return commands.toggleWrap(this.name, attributes)
        },
    }
  },
})

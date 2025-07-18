import { mergeAttributes, Node } from '@tiptap/core'

export interface SuggestionOptions {
  HTMLAttributes: Record<string, any>
}

export interface SuggestionAttributes {
  'data-action'?: 'add' | 'remove'
  'data-idx'?: number
  'data-id'?: number
}

declare module '@tiptap/core' {
  interface Commands<ReturnType> {
    suggestion: {
      /**
       * Inserts a suggestion element
       */
      setSuggestion: (attributes?: SuggestionAttributes, content?: string) => ReturnType
      /**
       * Removes the suggestion element
       */
      unsetSuggestion: () => ReturnType
      /**
       * Toggles the suggestion element
       */
      toggleSuggestion: (attributes?: SuggestionAttributes) => ReturnType
    }
  }
}

export const Suggestion = Node.create<SuggestionOptions>({
  name: 'suggestion',

  addOptions() {
    return {
      HTMLAttributes: {},
    }
  },

  group: 'block',

  content: 'block+',

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
      'data-idx': {
        default: null,
        parseHTML: element => {
          const value = element.getAttribute('data-idx')
          return value ? parseInt(value, 10) : null
        },
        renderHTML: attributes => {
          if (attributes['data-idx'] === null || attributes['data-idx'] === undefined) {
            return {}
          }
          return {
            'data-idx': attributes['data-idx'],
          }
        },
      },
      'data-id': {
        default: null,
        parseHTML: element => {
          const value = element.getAttribute('data-id')
          return value ? parseInt(value, 10) : null
        },
        renderHTML: attributes => {
          if (attributes['data-id'] === null || attributes['data-id'] === undefined) {
            return {}
          }
          return {
            'data-id': attributes['data-id'],
          }
        },
      },
    }
  },

  parseHTML() {
    return [
      {
        tag: 'div[data-suggestion]',
      },
      {
        tag: 'suggestion'
      }
    ]
  },

  renderHTML({ HTMLAttributes }) {
    const attrs = { ...HTMLAttributes }
    return [
      'div',
      mergeAttributes(
        {
          'data-suggestion': '',
          contenteditable: !attrs['data-action'], // <- Block editing if suggestion has action
        },
        this.options.HTMLAttributes,
        HTMLAttributes
      ),
      0,
    ]
  },

  addCommands() {
    return {
      setSuggestion: (attributes) =>
        ({ commands }) => {
          return commands.wrapIn(this.name, attributes)
        },
      unsetSuggestion: () =>
        ({ commands }) => {
          return commands.lift(this.name)
        },
      toggleSuggestion: (attributes) =>
        ({ commands }) => {
          return commands.toggleWrap(this.name, attributes)
        },
    }
  },
})
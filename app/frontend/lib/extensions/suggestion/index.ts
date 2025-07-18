import { mergeAttributes, Node, type Content } from '@tiptap/core'

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
       * Insere um elemento suggestion
       */
      setSuggestion: (attributes?: SuggestionAttributes, content?: string) => ReturnType
      /**
       * Remove o elemento suggestion
       */
      unsetSuggestion: () => ReturnType
      /**
       * Alterna o elemento suggestion
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
          contenteditable: !attrs['data-action'], // <- Se suggestion possuir action, não permite edição
        },
        this.options.HTMLAttributes,
        HTMLAttributes
      ),
      0,
    ]
  },

  addCommands() {
    return {
      setSuggestion: (attributes, content) => ({ commands }) => {
          return commands.insertContent({
            type: this.name,
            content: parseHTMLContent(content),
            attrs: attributes
          })
        },
      unsetSuggestion:
        () =>
        ({ commands }) => {
          return commands.lift(this.name)
        },
      toggleSuggestion:
        (attributes) =>
        ({ commands }) => {
          return commands.toggleWrap(this.name, attributes)
        },
    }
  },
})

export function parseHTMLContent(htmlString: string): any[] {
  const parser = new DOMParser()
  const doc = parser.parseFromString(htmlString, 'text/html')
  const content: any[] = []
  
  // Converte elementos HTML para formato do Tiptap
  Array.from(doc.body.children).forEach(element => {
    if (element.tagName === 'P') {
      content.push({
        type: 'paragraph',
        content: element.textContent ? [
          {
            type: 'text',
            text: element.textContent,
          }
        ] : [],
      })
    }
    // Adicione outros tipos de elementos conforme necessário
  })
  
  return content
}
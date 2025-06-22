import { Mark, mergeAttributes } from '@tiptap/core'

/**
 * Interface para definir as opções da nossa extensão.
 * Teremos que passar o 'id' e 'idx' ao aplicar a marca.
 */
export interface SuggestionOptions {
  id: string,
  idx: number,
}

// Declara o novo tipo para o módulo do Tiptap, para que os comandos fiquem disponíveis com tipagem
declare module '@tiptap/core' {
  interface Commands<ReturnType> {
    suggestion: {
      /**
       * Define uma marca de sugestão
       */
      setSuggestion: (attributes: SuggestionOptions) => ReturnType,
      /**
       * Alterna uma marca de sugestão
       */
      toggleSuggestion: (attributes: SuggestionOptions) => ReturnType,
      /**
       * Remove uma marca de sugestão
       */
      unsetSuggestion: () => ReturnType,
    }
  }
}

export const Suggestion = Mark.create<SuggestionOptions>({
  name: 'suggestion',

  // Adiciona os atributos 'id' e 'idx' à nossa marca.
  addAttributes() {
    return {
      id: {
        default: null,
        // Mapeia o atributo 'id' para o atributo 'data-id' no HTML
        parseHTML: element => element.getAttribute('data-id'),
        renderHTML: attributes => {
          if (!attributes.id) {
            return {}
          }
          return { 'data-id': attributes.id }
        },
      },
      idx: {
        default: null,
        // Mapeia o atributo 'idx' para o atributo 'data-idx' no HTML
        parseHTML: element => element.getAttribute('data-idx'),
        renderHTML: attributes => {
            if (!attributes.idx) {
                return {}
            }
          return { 'data-idx': attributes.idx }
        },
      }
    }
  },

  /**
   * Define como o Tiptap deve interpretar o HTML e reconhecer esta marca.
   * Ele vai reconhecer tanto a tag customizada <suggestion> quanto a tag <span> com o atributo data-suggestion.
   */
  parseHTML() {
    return [
      {
        tag: 'suggestion',
      },
      {
        tag: 'span[data-suggestion]',
      },
    ]
  },

  /**
   * Define como esta marca será renderizada para HTML.
   * @param HTMLAttributes - Os atributos definidos em `addAttributes` já processados.
   */
  renderHTML({ HTMLAttributes }) {
    // `mergeAttributes` junta os atributos que definimos com quaisquer outros que possam existir.
    // O '0' no final é um "buraco" onde o conteúdo (o texto) será inserido.
    return ['span', mergeAttributes(HTMLAttributes, { 'data-suggestion': '' }), 0]
  },

  // Adiciona comandos customizados para manipular a nossa marca.
  addCommands() {
    return {
      setSuggestion: attributes => ({ commands }) => {
        return commands.setMark(this.name, attributes)
      },
      toggleSuggestion: attributes => ({ commands }) => {
        return commands.toggleMark(this.name, attributes)
      },
      unsetSuggestion: () => ({ commands }) => {
        return commands.unsetMark(this.name)
      },
    }
  },
})
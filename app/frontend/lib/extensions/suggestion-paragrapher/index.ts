import Paragraph from '@tiptap/extension-paragraph';
import { mergeAttributes } from '@tiptap/core';

export const SuggestionParagraph = Paragraph.extend({
  addAttributes() {
    return {
      // Herda os atributos originais (como 'textAlign')
      ...this.parent?.(),

      // Nosso novo atributo para o tipo de sugestão
      suggestionType: {
        default: null,
        // Não é necessário `parseHTML` complexo, Tiptap pode mapear automaticamente
        // mas vamos definir explicitamente por clareza.
        parseHTML: element => element.getAttribute('data-suggestion-type'),
        renderHTML: attributes => {
          if (!attributes.suggestionType) {
            return {};
          }
          // Renderiza como data-suggestion-type="add" ou data-suggestion-type="delete"
          return {
            'data-suggestion-type': attributes.suggestionType,
          };
        },
      },
    };
  },
});
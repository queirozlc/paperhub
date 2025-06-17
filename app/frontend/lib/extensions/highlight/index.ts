import { Mark } from '@tiptap/core';

export const HighlightedParagraph = Mark.create({
  name: 'hoverMark',

  addAttributes() {
    return {
      // Atributos padrão que não precisamos no momento
    };
  },

  parseHTML() {
    return [
      {
        tag: 'span[data-hover-mark]',
      },
    ];
  },

  renderHTML({ HTMLAttributes }) {
    return ['span', {
      ...HTMLAttributes,
      'data-hover-mark': '',
      class: 'hover-mark-span'
    }, 0];
  },
})
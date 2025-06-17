import { Mark, type RawCommands } from '@tiptap/core';

export const HighlightedParagraph = Mark.create({
  name: 'hoverMark',

  addAttributes() {
    return {
      id: 0
    };
  },

  parseHTML() {
    return [
      {
        tag: 'span[data-hover-mark]',
      },
    ];
  },

  renderHTML({ mark, HTMLAttributes }) {
    return ['span', {
      ...HTMLAttributes,
      'data-hover-mark': '',
      class: 'hover-mark-span',
      id: mark.attrs.id || null,
    }, 0];
  },

  /*addCommands() {
    return {
    }
  }*/
})
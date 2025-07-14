import { Node } from '@tiptap/core'
import { SvelteNodeViewRenderer } from 'svelte-tiptap'
import TableOfContentsNodeComponent from './table-of-contents-node.svelte'

declare module '@tiptap/core' {
  interface Commands<ReturnType> {
    tableOfContentsNode: {
      insertTableOfContents: () => ReturnType
    }
  }
}

export const TableOfContentsNode = Node.create({
  name: 'tableOfContentsNode',
  group: 'block',
  atom: true,
  selectable: true,
  draggable: false,
  inline: false,

  parseHTML() {
    return [{ tag: 'div[data-type="table-of-content"]' }]
  },

  renderHTML({ HTMLAttributes }) {
    return ['div', { ...HTMLAttributes, 'data-type': 'table-of-content' }]
  },

  addNodeView() {
    return SvelteNodeViewRenderer(TableOfContentsNodeComponent)
  },

  addCommands() {
    return {
      insertTableOfContents:
        () =>
        ({ commands }) => {
          return commands.insertContent({
            type: this.name,
          })
        },
    }
  },
})

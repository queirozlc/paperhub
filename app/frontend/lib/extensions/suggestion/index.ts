import { mergeAttributes, Node } from '@tiptap/core'
import type { Node as NodeType } from '@tiptap/pm/model'
import { NodeSelection } from '@tiptap/pm/state'
import { SvelteNodeViewRenderer } from 'svelte-tiptap'
import SuggestionView from './view.svelte'

export interface SuggestionOptions {
  HTMLAttributes: Record<string, any>
}

export type Action = 'add' | 'remove'

export interface SuggestionAttributes {
  'data-action'?: Action
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
      /**
       * Searches for and selects a node of type "suggestion" that has the specified attributes.
       * - If you do not want to filter the search by a certain attribute, do not specify it or specify it as `undefined`
       * - If you want a certain attribute to not exist in the node, specify it as `null`
       * - If you want to select a node that has a certain value in its attribute, specify it
       * 
       * Examples:
       * - `{ "data-id": 1 }` Selects the node whose "data-id" attribute value is "1"
       * - `{ "data-id": null }` Selects the node that does not have a "data-id"
       * - `{ "data-id": undefined }` It doesn't matter if "data-id" exists. It is not considered in the search.
       */
      selectSuggestion: (attributes: SuggestionAttributes) => ReturnType
      /**
       * Removes all "diff" marks from a selected node
       */
      removeDiffsFromSelected: () => ReturnType

      //removeActionFromSelected: () => ReturnType

      removeSelectedSuggestionContainer: () => ReturnType
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

  addNodeView() {
    return SvelteNodeViewRenderer(SuggestionView)
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

      selectSuggestion: (attributes) =>
        ({ tr }) => {
          
          //TODO: Implementar validação de dispatch

          tr.doc.descendants((node, pos) => {
            if (node.type.name === 'suggestion' && attributesMatch(node, attributes)) {
              const selection = NodeSelection.create(tr.doc, pos)
              tr.setSelection(selection)
              return false // Stops searching
            }

            return true // Continues searching
          })

          return true
        },

      removeDiffsFromSelected: () =>
        ({ state, tr }) => {
          const pos = tr.selection.from
          const node = tr.doc.nodeAt(pos);
          const diffType = state.schema.marks.diff;

          //TODO: Implementar validação de dispatch

          if (!node) {
            return false;
          }
          
          // Função recursiva para percorrer todos os nós filhos
          function traverseNode(currentNode: NodeType, currentPos: number) {
            if (currentNode.isText) {
              // Para nós de texto, verificar e remover marks "diff"
              if (currentNode.marks.some(mark => mark.type === diffType)) {
                  tr.removeMark(currentPos, currentPos + currentNode.nodeSize, diffType);
              }
            } else {
              // Para nós não-texto, percorrer recursivamente todos os filhos
              let childPos = currentPos + 1; // +1 para entrar no nó
              
              currentNode.forEach((child, offset) => {
                  const absoluteChildPos = childPos + offset;
                  traverseNode(child, absoluteChildPos);
              });
            }
          }

          // Iniciar a traversal a partir do nó na posição especificada
          traverseNode(node, pos);

          return true
        },

      /*removeActionFromSelected: () =>
        ({ state, tr }) => {
          const pos = tr.selection.from
          const node = state.doc.nodeAt(pos);
          const attrs = { ...node.attrs }
          delete attrs["data-action"]
          tr.setNodeMarkup(pos, null, attrs)
          return true
        },*/
        
      removeSelectedSuggestionContainer: () =>
        ({ tr }) => {

          //TODO: Implementar validação de dispatch

          // 1. Obtém o nó na posição especificada.
          const pos = tr.selection.from
          const node = tr.doc.nodeAt(pos);

          // 2. Verifica se é um nó de bloco.
          if (node && node.isBlock) {
            // 3. Obtém o conteúdo do nó.
            const content = node.content;

            // 4. Cria uma nova transação para substituir o nó.
            tr.replaceWith(pos, pos + node.nodeSize, content);
          }

          return true;
        }
    }
  },
})

/**
 * Loops through specified attributes and checks whether the `node` has those attributes
 * @param node Node to be checked
 * @param attributes Expected attributes in the node
 * @returns `true` if the expected attributes exist on the node and their values are equal. `false` otherwise
 */
function attributesMatch(node: NodeType, attributes: SuggestionAttributes) {
  let check = true
  Object.keys(attributes).forEach(attr => {
    if (!attributeMatch(node, attributes, attr)) {
      check = false
      return false //TODO: Verificar se isso interrompe iteração
    }
  })
  return check
}

function attributeMatch(node: NodeType, attributes: SuggestionAttributes, attr: string) {
  return attributes[attr] === undefined
    || ( attributes[attr] === null && node.attrs[attr] === null )
    || ( attributes[attr] === node.attrs[attr] )
}
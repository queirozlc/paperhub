import { Editor, mergeAttributes, Node } from '@tiptap/core'
import type { Fragment, Node as NodeType } from '@tiptap/pm/model'
import { NodeSelection, TextSelection } from '@tiptap/pm/state'
import { SvelteNodeViewRenderer } from 'svelte-tiptap'
import AiSuggestionView from '$lib/extensions/ai-suggestion/view.svelte'
import { generateJSON } from '@tiptap/html'

export type Action = 'add' | 'remove'

export interface AiSuggestionAttributes {
  'data-action'?: Action
  'data-idx'?: number
  'data-id'?: number

  'data-empty'?: boolean
  'data-empty-brother'?: boolean
}

declare module '@tiptap/core' {
  interface Commands<ReturnType> {
    aiSuggestion: {
      /**
       * Inserts a aiSuggestion element
       */
      setAiSuggestion: (
        attributes?: AiSuggestionAttributes,
        content?: string
      ) => ReturnType
      /**
       * Removes the aiSuggestion element
       */
      unsetAiSuggestion: () => ReturnType
      /**
       * Toggles the aiSuggestion element
       */
      toggleAiSuggestion: (attributes?: AiSuggestionAttributes) => ReturnType
      /**
       * Searches for and selects a node of type "aiSuggestion" that has the specified attributes.
       * - If you do not want to filter the search by a certain attribute, do not specify it or specify it as `undefined`
       * - If you want a certain attribute to not exist in the node, specify it as `null`
       * - If you want to select a node that has a certain value in its attribute, specify it
       *
       * Examples:
       * - `{ "data-id": 1 }` Selects the node whose "data-id" attribute value is "1"
       * - `{ "data-id": null }` Selects the node that does not have a "data-id"
       * - `{ "data-id": undefined }` It doesn't matter if "data-id" exists. It is not considered in the search.
       */
      selectAiSuggestion: (attributes: AiSuggestionAttributes) => ReturnType
      /**
       * Removes all "diff" marks from a selected node
       */
      removeDiffsFromSelected: () => ReturnType
      /**
       * Remove "action" attribute from selected "aiSuggestion" node
       */
      removeActionFromSelected: () => ReturnType
      /**
       * Removes the selected "aiSuggestion" node, but keeps all its contents
       */
      removeSelectedAiSuggestionContainer: () => ReturnType
      /**
       * Replaces the selected "aiSuggestion" node, updating its attributes and content
       * @param attributes New node attributes
       * @param content Node content as HTML (string)
       */
      updateAiSuggestion: (
        attributes: AiSuggestionAttributes,
        content: string
      ) => ReturnType
      /**
       * Adds a "aiSuggestion" node after/below the selected node\
       * **Note:** A node must be selected (NodeSelection)
       * @param attributes Attributes of the new node
       * @param content Content of new node in HTML string format
       */
      addAiSuggestionBellow: (
        attributes: AiSuggestionAttributes,
        content: string
      ) => ReturnType
    }
  }
}

export const AiSuggestion = Node.create(
  /*<AiSuggestionOptions>*/ {
    name: 'aiSuggestion',

    addOptions() {
      return {
        HTMLAttributes: {},
      }
    },

    group: 'block',

    content: 'block*',

    defining: true,

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
        'data-idx': {
          default: null,
          parseHTML: (element) => {
            const value = element.getAttribute('data-idx')
            return value ? parseInt(value, 10) : null
          },
          renderHTML: (attributes) => {
            if (
              attributes['data-idx'] === null ||
              attributes['data-idx'] === undefined
            ) {
              return {}
            }
            return {
              'data-idx': attributes['data-idx'],
            }
          },
        },
        'data-id': {
          default: null,
          parseHTML: (element) => {
            const value = element.getAttribute('data-id')
            return value ? parseInt(value, 10) : null
          },
          renderHTML: (attributes) => {
            if (
              attributes['data-id'] === null ||
              attributes['data-id'] === undefined
            ) {
              return {}
            }
            return {
              'data-id': attributes['data-id'],
            }
          },
        },
        'data-empty': {
          default: false,
          parseHTML: (element) => element.getAttribute('data-empty'),
          renderHTML: (attributes) => {
            if (!attributes['data-empty']) {
              return {}
            }
            return {
              'data-empty': attributes['data-empty'],
            }
          },
        },
        'data-empty-brother': {
          default: false,
          parseHTML: (element) => element.getAttribute('data-empty-brother'),
          renderHTML: (attributes) => {
            if (!attributes['data-empty-brother']) {
              return {}
            }
            return {
              'data-empty-brother': attributes['data-empty-brother'],
            }
          },
        },
      }
    },

    parseHTML() {
      return [
        {
          tag: 'div[data-ai-suggestion]',
        },
        {
          tag: 'ai-suggestion',
        },
      ]
    },

    renderHTML({ HTMLAttributes }) {
      const attrs = { ...HTMLAttributes }
      return [
        'div',
        mergeAttributes(
          {
            'data-ai-suggestion': '',
            contenteditable: !attrs['data-action'], // <- Block editing if aiSuggestion has action
          },
          this.options.HTMLAttributes,
          HTMLAttributes
        ),
        0,
      ]
    },

    addNodeView() {
      return SvelteNodeViewRenderer(AiSuggestionView)
    },

    addCommands() {
      return {
        setAiSuggestion:
          (attributes) =>
          ({ commands }) => {
            return commands.wrapIn(this.name, attributes)
          },

        unsetAiSuggestion:
          () =>
          ({ commands }) => {
            return commands.lift(this.name)
          },

        toggleAiSuggestion:
          (attributes) =>
          ({ commands }) => {
            return commands.toggleWrap(this.name, attributes)
          },

        selectAiSuggestion:
          (attributes) =>
          ({ tr }) => {
            //TODO: Implementar validação de dispatch

            let founded = false

            tr.doc.descendants((node, pos) => {
              if (
                node.type.name === 'aiSuggestion' &&
                attributesMatch(node, attributes)
              ) {
                const selection = NodeSelection.create(tr.doc, pos)
                tr.setSelection(selection)
                founded = true
                return false // Stops searching
              }

              return true // Continues searching
            })

            if (!founded) {
              tr.deleteSelection()
            }

            return true
          },

        removeDiffsFromSelected:
          () =>
          ({ state, tr }) => {
            const pos = tr.selection.from
            const node = tr.doc.nodeAt(pos)
            const diffType = state.schema.marks.diff

            //TODO: Implementar validação de dispatch

            if (!node) {
              return false
            }

            /**
             * Recursive function to traverse all child nodes
             */
            function traverseNode(currentNode: NodeType, currentPos: number) {
              if (currentNode.isText) {
                // For text nodes, check and remove "diff" marks
                if (currentNode.marks.some((mark) => mark.type === diffType)) {
                  tr.removeMark(
                    currentPos,
                    currentPos + currentNode.nodeSize,
                    diffType
                  )
                }
              } else {
                // For non-text nodes, recursively traverse all children
                const childPos = currentPos + 1 // +1 to enter the node

                currentNode.forEach((child, offset) => {
                  const absoluteChildPos = childPos + offset
                  traverseNode(child, absoluteChildPos)
                })
              }
            }

            traverseNode(node, pos)

            return true
          },

        removeActionFromSelected:
          () =>
          ({ state, tr }) => {
            const pos = tr.selection.from
            const node = state.doc.nodeAt(pos)
            const attrs = { ...node.attrs }
            delete attrs['data-action']
            tr.setNodeMarkup(pos, null, attrs)
            return true
          },

        removeSelectedAiSuggestionContainer:
          () =>
          ({ tr }) => {
            //TODO: Implementar validação de dispatch

            const pos = tr.selection.from
            const node = tr.doc.nodeAt(pos)

            if (node && node.isBlock) {
              const content = node.content
              tr.replaceWith(pos, pos + node.nodeSize, content)
            }

            return true
          },

        updateAiSuggestion:
          (attributes: AiSuggestionAttributes, content: string) =>
          ({ tr, state, editor }) => {
            const { selection } = tr

            let fragment: Fragment = null
            if (content.length > 0) {
              const json = generateJSON(
                content,
                editor.extensionManager.extensions
              )
              fragment = state.schema.nodeFromJSON(json).content
            }

            const node = state.schema.nodes.aiSuggestion.create(
              attributes,
              fragment
            )

            tr.replaceSelectionWith(node)
            tr.setSelection(NodeSelection.create(tr.doc, selection.from))

            return true
          },

        addAiSuggestionBellow:
          (attributes: AiSuggestionAttributes, content: string) =>
          ({ tr, state, editor }) => {
            if (!(tr.selection instanceof NodeSelection)) {
              throw 'Seleção precisa ser do tipo NodeSelection'
            }

            const node = tr.selection.node
            const pos = tr.selection.from

            const json = generateJSON(
              content,
              editor.extensionManager.extensions
            )
            const fragment = state.schema.nodeFromJSON(json).content

            const suggestionAdd = state.schema.nodes.aiSuggestion.create(
              attributes,
              fragment
            )

            const afterNodePos = pos + node.nodeSize
            tr.insert(afterNodePos, suggestionAdd)

            return true
          },
      }
    },

    addKeyboardShortcuts() {
      return {
        Enter: escapeAiSuggestionNodeIfCursorAtEnd,
        // Preserve default behavior for Shift+Enter and Ctrl+Enter:
        'Shift-Enter': () => false,
        'Mod-Enter': () => false,
      }
    },
  }
)

/**
 * Loops through specified attributes and checks whether the `node` has those attributes
 * @param node Node to be checked
 * @param attributes Expected attributes in the node
 * @returns `true` if the expected attributes exist on the node and their values are equal. `false` otherwise
 */
function attributesMatch(node: NodeType, attributes: AiSuggestionAttributes) {
  let check = true
  Object.keys(attributes).forEach((attr) => {
    if (!attributeMatch(node, attributes, attr)) {
      check = false
      return false //TODO: Verificar se isso interrompe iteração
    }
  })
  return check
}

function attributeMatch(
  node: NodeType,
  attributes: AiSuggestionAttributes,
  attr: string
) {
  return (
    attributes[attr] === undefined ||
    (attributes[attr] === null && node.attrs[attr] === null) ||
    attributes[attr] === node.attrs[attr]
  )
}

/**
 * Function for use in addKeyboardShortcuts.
 *
 * Checks if the cursor is at the end of the aiSuggestion node. If so, adds a new empty paragraph after/below/outside it.
 *
 * @param editor Tiptap Editor
 * @returns `true` to prevent default behavior. `falte` to keep default behavior
 */
function escapeAiSuggestionNodeIfCursorAtEnd({ editor }: { editor: Editor }) {
  const { state, schema, view } = editor
  const { selection, doc } = state
  const { $from } = selection

  const suggestionType = 'aiSuggestion'

  /**
   * Search node aiSuggestion where the cursor is.
   *
   * Imagine the cursor is inside a diff node that is inside a paragraph that is inside a aiSuggestion node.
   * This function, starting from the diff node, regresses until it finds the aiSuggestion node and returns it.
   *
   * If the cursor is not within a aiSuggestion node, even indirectly, it returns `null`.
   *
   * @returns AiSuggestion node or `null` if the cursor is not within a aiSuggestion node.
   */
  function findAiSuggestionContainer(): NodeType {
    let depth = $from.depth
    let currentNode: NodeType

    do {
      currentNode = $from.node(depth--)
    } while (
      currentNode.type.name !== suggestionType &&
      currentNode.type.name !== 'doc'
    )

    if (currentNode === doc) {
      return null
    }

    return currentNode
  }

  /**
   * Checks if cursor is inside and at the end of the node.
   *
   * @param node Node
   * @param nodePos `node` position
   * @returns `true` if cursor is inside and at the end of the node. `false` otherwise.
   */
  function isCursorInTheEndOfTheNode(node: NodeType, nodePos: number) {
    const nodeEndPos = nodePos + node.nodeSize - 2
    const cursorPos = $from.pos

    const isCursorInTheEnd = nodeEndPos === cursorPos
    return isCursorInTheEnd
  }

  /**
   * Returns the Node position from a Node element
   *
   * @param targetNode Node you want to find position
   * @returns Position
   */
  function getNodePos(targetNode: NodeType): number {
    let nodePos = -1
    doc.descendants((node, pos) => {
      if (node === targetNode) {
        nodePos = pos
        return false
      }
      return true
    })
    return nodePos
  }

  /**
   * Creates a new empty paragraph node below/after a node
   * @param node Node that will receive the paragraph after/below/outside it
   * @param nodePos `node` position
   */
  function createParagraphBelow(node: NodeType, nodePos: number): void {
    const paragraph = schema.nodes.paragraph.create()

    const afterNodePos = nodePos + node.nodeSize

    const tr = view.state.tr
    tr.insert(afterNodePos, paragraph)
    tr.setSelection(TextSelection.create(tr.doc, afterNodePos + 1))
    view.dispatch(tr)
  }

  const suggestionNode = findAiSuggestionContainer()
  if (suggestionNode === null) {
    return false
  }
  const suggestionNodePos = getNodePos(suggestionNode)
  if (!isCursorInTheEndOfTheNode(suggestionNode, suggestionNodePos)) {
    return false
  }
  createParagraphBelow(suggestionNode, suggestionNodePos)
  return true // Prevent default
}

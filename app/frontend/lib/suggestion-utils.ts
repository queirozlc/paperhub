import type { Editor } from "svelte-tiptap"
import { parseHTMLContent } from "./extensions/suggestion"
import type { ChainedCommands } from "@tiptap/core"

/**
 * Loops through HTML (as a string) adding the "data-id" attribute to all <suggestion> elements.
 * 
 * "data-id" is an incremental number.
 * 
 * @param modifiedDocumentContent HTML as string with suggestions from AI
 * @param nextSuggestionIndex index of the last suggestion made by AI + 1
 * @returns HTML as string with all suggestions having a "data-id" attribute
 */
export function setIdsToNewSuggestions(modifiedDocumentContent: string, nextSuggestionIndex: number) {
  const parser = new DOMParser()
  const doc = parser.parseFromString(modifiedDocumentContent, "text/html")

  const selector = 'suggestion:not([data-id])';
  const suggestions: NodeListOf<HTMLSpanElement> = doc.querySelectorAll(selector);

  if (suggestions.length === 0) {
    return
  }

  suggestions.forEach(s => {
    const idx = parseInt(s.getAttribute('data-idx'))
    s.setAttribute('data-id', String(nextSuggestionIndex + idx))
    s.removeAttribute('data-idx')
  });

  return doc.documentElement.outerHTML;
}

/**
 * See the differences in the suggestion to be applied
 * @param editor Tiptap Editor
 * @param suggestionId Suggestion node's "data-id" attribute
 * @param suggestionContent Content to be displayed in the suggestion changes
 * @returns true if the suggestion was displayed, false if not found
 */
export function displaySuggestion(editor: Editor, suggestionId: number, suggestionContent: string) {
  const { state } = editor
  const { doc } = state
  let nodePos: { init: number; end: number } = null;

  // Percorre todo o documento procurando pelo nó
  doc.descendants((node, pos) => {
    // Verifica se é o nó que estamos procurando
    if (node.type.name === 'suggestion' && node.attrs['data-id'] === suggestionId && !node.attrs['data-action']) {
      // Calcula a posição após o nó (pos + tamanho do nó)
      nodePos = {
        init: pos,
        end: pos + node.nodeSize,
      }
      return false // Para a busca
    }
    return true // Continua a busca
  })
  
  if (nodePos == null) {
    return false
  }

  const chain = editor.chain().focus()
  highlightOriginalContent(chain, nodePos.init)
  addSecondSuggestionNode(chain, {
    id: suggestionId,
    pos: nodePos.end,
    content: suggestionContent,
  })
  chain.run()

  return true
}

function highlightOriginalContent(chain: ChainedCommands, suggestionNodePosition: number) {
  chain.command(({ tr }) => {
    const node = tr.doc.nodeAt(suggestionNodePosition)
    tr.setNodeMarkup(suggestionNodePosition, undefined, {
      ...node?.attrs,
      "data-action": "remove",
    });

    return true;
  })
}

function addSecondSuggestionNode(chain: ChainedCommands, suggesion: { id: number; pos: number; content: string }) {
  chain.insertContentAt(suggesion.pos, {
    type: 'suggestion',
    attrs: {
      "data-action": "add",
      "data-id": suggesion.id,
    },
    content: parseHTMLContent(suggesion.content),
  })
}
import type { Editor } from "svelte-tiptap"
import { parseHTMLContent } from "./extensions/suggestion"
import type { ChainedCommands } from "@tiptap/core"
import * as Diff from 'diff';
import { generateHTML, generateJSON } from "@tiptap/html"
import { editorExtensions } from './extensions/index'
import type { Node } from "@tiptap/pm/model";

type NodePos = {
  init: number;
  end: number;
}

type NodeData = {
  content: string;
  pos: NodePos;
}

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

  const original = getSuggestionNodeById(editor, suggestionId)
  
  if (original == null) {
    return false
  }

  const [ originalDiff, suggestionDiff ] = highlightHtmllDifferences(original.content, suggestionContent)

  const chain = editor.chain()
    .focus()

  addSecondSuggestionNode(chain, {
    id: suggestionId,
    pos: original.pos.end,
    content: suggestionDiff,
  })

  highlightOriginalContent(chain, original.pos, originalDiff)

  chain.run()

  return true
}

function getSuggestionNodeById(editor: Editor, suggestionId: number): NodeData | null {
  const { state } = editor
  const { doc } = state

  let founded: NodeData = null

  doc.descendants((node, pos) => {

    if (node.type.name === 'suggestion'
    &&  node.attrs['data-id'] === suggestionId
    && !node.attrs['data-action']) {

      founded = {
        content: extractNodeHtmlContent(node),
        pos: {
          init: pos,
          end: pos + node.nodeSize,
        }
      }

      return false // Stops searching
    }

    return true // Continues searching
  })

  return founded
}

function extractNodeHtmlContent(node: Node): string {
  const html = generateHTML(node.toJSON(), editorExtensions)
  return html.replace(/ xmlns="[^"]*"/g, '')
}

function highlightOriginalContent(chain: ChainedCommands, pos: NodePos, content: string) {
  chain
    .deleteRange({
      from: pos.init + 1,
      to: pos.end - 1
    })
    .insertContentAt(pos.init + 1, content)
    .command(({ tr }) => {
      const node = tr.doc.nodeAt(pos.init)

      if (!node) {
        return true;
      }

      // Add "data-action" attribute
      tr.setNodeMarkup(pos.init, undefined, {
        ...node?.attrs,
        "data-action": "remove",
      })

      // Find last empty paragraph and remove it
      node.descendants((descendant, childPos) => {
        if (descendant.type.name === 'paragraph' && descendant.content.size === 0) {
          const absolutePos = pos.init + 1 + childPos
          tr.delete(absolutePos, absolutePos + descendant.nodeSize)
          return false // Stop the search
        }
      })

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
    content: generateJSON(suggesion.content, editorExtensions).content
  })
}

function highlightHtmllDifferences(html1: string, html2: string): string[] {
  const changes = Diff.diffWords(html1, html2);
  
  let string1diff = '';
  let string2diff = '';
  
  changes.forEach(change => {
    if (change.added) {
      string2diff += `<diff>${change.value}</diff>`;
    } else if (change.removed) {
      string1diff += `<diff>${change.value}</diff>`;
    } else {
      string1diff += change.value;
      string2diff += change.value;
    }
  });
  
  return [ string1diff, string2diff ];
}
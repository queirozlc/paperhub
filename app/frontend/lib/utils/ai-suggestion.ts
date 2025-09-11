import { generateHTML } from '@tiptap/html'
import type { Node } from '@tiptap/pm/model'
import { editorExtensions as extensions } from '$lib/extensions/extension-kit'

/**
 * Loops through HTML (as a string) adding the "data-id" attribute to all <suggestion> elements.
 *
 * "data-id" is an incremental number.
 *
 * @param modifiedDocumentContent HTML as string with suggestions from AI
 * @param nextSuggestionIndex index of the last suggestion made by AI + 1
 * @returns HTML as string with all suggestions having a "data-id" attribute
 */
export function setIdsToNewAiSuggestions(
  modifiedDocumentContent: string,
  nextSuggestionIndex: number
): string {
  const parser = new DOMParser()
  const doc = parser.parseFromString(modifiedDocumentContent, 'text/html')

  const selector = 'ai-suggestion:not([data-id])'
  const suggestions: NodeListOf<HTMLSpanElement> =
    doc.querySelectorAll(selector)

  if (suggestions.length === 0) {
    return
  }

  suggestions.forEach((s) => {
    const idx = parseInt(s.getAttribute('data-idx'))
    s.setAttribute('data-id', String(nextSuggestionIndex + idx))
    s.removeAttribute('data-idx')
  })

  return doc.documentElement.outerHTML
}

/**
 * Extract HTML content from node as string
 * @param node Tiptap Node to extract HTML content from
 * @returns HTML as string
 */
export function extractNodeHtmlContent(node: Node): string {
  const html = generateHTML(node.toJSON(), extensions)
  return html.replace(/ xmlns="[^"]*"/g, '')
}

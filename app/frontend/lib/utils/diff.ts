import * as Diff from 'diff'

/**
 * Finds the differences between two strings. Their differences are circled with the <diff> tag
 * @param html1 HTML string to compare
 * @param html2 HTML string to compare
 * @returns List with two strings. Each has its differences highlighted
 */
export function highlightHtmlDifferences(
  html1: string,
  html2: string
): string[] {
  const changes = Diff.diffWords(html1, html2)

  let string1diff = ''
  let string2diff = ''

  changes.forEach((change) => {
    if (change.added) {
      string2diff += `<diff>${change.value}</diff>`
    } else if (change.removed) {
      string1diff += `<diff>${change.value}</diff>`
    } else {
      string1diff += change.value
      string2diff += change.value
    }
  })

  return [string1diff, string2diff]
}

import { diffWords, type ChangeObject } from 'diff'

type HtmlChangeObject = ChangeObject<string> & {
  tag: boolean
}

/**
 * Finds the differences between two strings. Their differences are circled with the <diff> tag
 * @param html1 Old version of HTML string to compare
 * @param html2 New version of HTML string to compare
 * @returns List with two strings. Each has its differences highlighted with the <diff> tag
 */
export function diffHtml(html1: string, html2: string): string[] {
  const diff = diffWords(html1, html2)
  const changes = processHtmlTags(diff)
  const strings = buildDiffStrings(changes)

  return strings
}

/**
 * Processes diff changes to properly handle HTML tags
 */
function processHtmlTags(changes: ChangeObject<string>[]): HtmlChangeObject[] {
  function getTagCharIdxs(value: string, cursor: number) {
    const openTagIdx = maxIfNegative(value.indexOf('<', cursor))
    const closeTagIdx = maxIfNegative(value.indexOf('>', cursor))
    return { openTagIdx, closeTagIdx }
  }

  function notContainAnyTagChar(i: number, j: number): boolean {
    return i === Number.MAX_SAFE_INTEGER && j === Number.MAX_SAFE_INTEGER
  }

  const result: HtmlChangeObject[] = []
  let isTagOpen = false

  for (const change of changes) {
    let cursor = 0
    let currentValue = change.value

    while (currentValue.length > 0) {
      const { openTagIdx, closeTagIdx } = getTagCharIdxs(currentValue, cursor)

      // There is neither < nor >
      if (notContainAnyTagChar(openTagIdx, closeTagIdx)) {
        result.push({ ...change, value: currentValue, tag: isTagOpen })
        currentValue = ''
      }
      // There is > first
      else if (closeTagIdx < openTagIdx) {
        const tag = currentValue.substring(0, closeTagIdx + 1)
        if (tag.length > 0) {
          result.push({ ...change, value: tag, tag: true })
        }
        currentValue = currentValue.substring(closeTagIdx + 1)
        cursor = 0
        isTagOpen = false
      }
      // There is < first
      else {
        const pre = currentValue.substring(0, openTagIdx)
        if (pre.length > 0) {
          result.push({ ...change, value: pre, tag: isTagOpen })
        }
        currentValue = currentValue.substring(openTagIdx)
        cursor = 1
        isTagOpen = true
      }
    }
  }

  return result
}

function buildDiffStrings(changes: HtmlChangeObject[]): string[] {
  let diff1 = ''
  let diff2 = ''

  changes.forEach((change) => {
    if (change.added) {
      diff2 += surroundWithDiffTag(change.value, !change.tag)
    } else if (change.removed) {
      diff1 += surroundWithDiffTag(change.value, !change.tag)
    } else {
      diff1 += change.value
      diff2 += change.value
    }
  })

  return [diff1, diff2]
}

function surroundWithDiffTag(value: string, surroundWithTag: boolean = true) {
  if (surroundWithTag) {
    return `<diff>${value}</diff>`
  }
  return value
}

function maxIfNegative(n: number) {
  if (n === -1) {
    return Number.MAX_SAFE_INTEGER
  }
  return n
}

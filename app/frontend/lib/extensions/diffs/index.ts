import { Extension, Mark, mergeAttributes } from '@tiptap/core'
import { Plugin, PluginKey } from '@tiptap/pm/state'
import { diffWords } from 'diff'

declare module '@tiptap/core' {
  interface Commands<ReturnType> {
    diffViewer: {
      setDiff: (fromHTML: string, toHTML: string) => ReturnType
    }
  }
}

// Define the Insertion mark (for added content)
const DiffInsertion = Mark.create({
  name: 'diffInsertion',

  addOptions() {
    return {
      HTMLAttributes: {},
    }
  },

  parseHTML() {
    return [
      {
        tag: 'ins',
      },
    ]
  },

  renderHTML({ HTMLAttributes }) {
    return [
      'ins',
      mergeAttributes(this.options.HTMLAttributes, HTMLAttributes),
      0,
    ]
  },
})

// Define the Deletion mark (for removed content)
const DiffDeletion = Mark.create({
  name: 'diffDeletion',

  addOptions() {
    return {
      HTMLAttributes: {},
    }
  },

  parseHTML() {
    return [
      {
        tag: 'delete',
      },
    ]
  },

  renderHTML({ HTMLAttributes }) {
    return [
      'delete',
      mergeAttributes(this.options.HTMLAttributes, HTMLAttributes),
      0,
    ]
  },
})

interface DiffOptions {
  fromHTML: string
  toHTML: string

  editable: boolean

  setDiffCount: (count: number) => void
}

// Main Diff Viewer Extension
export const Diff = Extension.create<DiffOptions>({
  name: 'diffViewer',

  addOptions() {
    return {
      fromHTML: '',
      toHTML: '',
      setDiffCount: () => {},
      editable: true,
    }
  },

  addExtensions() {
    return [DiffInsertion, DiffDeletion]
  },

  onCreate() {
    // Generate diff content when editor is created
    if (this.options.fromHTML && this.options.toHTML) {
      const diffContent = generateDiffContent(
        this.options.fromHTML,
        this.options.toHTML,
        this.options.setDiffCount
      )
      this.editor.commands.setContent(diffContent)

      if (!this.options.editable) {
        this.editor.setEditable(false)
      }
    }
  },

  addProseMirrorPlugins() {
    return [
      new Plugin({
        key: new PluginKey('diffViewer'),
        props: {
          editable: () => this.options.editable,
        },
      }),
    ]
  },

  addCommands() {
    return {
      setDiff:
        (fromHTML: string, toHTML: string) =>
        ({ commands }) => {
          const diffContent = generateDiffContent(
            fromHTML,
            toHTML,
            this.options.setDiffCount
          )
          return commands.setContent(diffContent)
        },
    }
  },
})

function generateDiffContent(
  fromHTML: string,
  toHTML: string,
  setDiffCount: (count: number) => void
): string {
  // Parse HTML to extract text content while preserving structure
  const parser = new DOMParser()
  const fromDoc = parser.parseFromString(fromHTML, 'text/html')
  const toDoc = parser.parseFromString(toHTML, 'text/html')

  // Process the diff at the DOM level to preserve structure
  const diffHTML = diffNodes(fromDoc.body, toDoc.body, setDiffCount)

  return diffHTML
}

function diffNodes(
  fromNode: Node,
  toNode: Node,
  setDiffCount: (count: number) => void
): string {
  // Helper function to get node structure
  const getNodeInfo = (
    node: Node
  ): { tag: string; attrs: string; content: string } => {
    if (node.nodeType === Node.TEXT_NODE) {
      return { tag: '', attrs: '', content: node.textContent || '' }
    }

    if (node.nodeType === Node.ELEMENT_NODE) {
      const element = node as Element
      const tag = element.tagName.toLowerCase()
      const attrs = Array.from(element.attributes)
        .map((attr) => `${attr.name}="${attr.value}"`)
        .join(' ')
      return { tag, attrs, content: element.innerHTML }
    }

    return { tag: '', attrs: '', content: '' }
  }

  // Compare nodes recursively
  const compareNodes = (
    from: Node,
    to: Node,
    setDiffCount: (count: number) => void
  ): string => {
    const fromInfo = getNodeInfo(from)
    const toInfo = getNodeInfo(to)

    // If both are text nodes, diff the text
    if (from.nodeType === Node.TEXT_NODE && to.nodeType === Node.TEXT_NODE) {
      const { html, count } = diffText(fromInfo.content, toInfo.content)
      console.log({ fromInfo, toInfo, count })
      setDiffCount(count)
      return html
    }

    // If both are elements with the same tag
    if (
      from.nodeType === Node.ELEMENT_NODE &&
      to.nodeType === Node.ELEMENT_NODE &&
      fromInfo.tag === toInfo.tag
    ) {
      // Diff the children
      const fromChildren = Array.from(from.childNodes)
      const toChildren = Array.from(to.childNodes)

      let result = ''
      const maxLength = Math.max(fromChildren.length, toChildren.length)

      for (let i = 0; i < maxLength; i++) {
        if (i < fromChildren.length && i < toChildren.length) {
          result += compareNodes(fromChildren[i], toChildren[i], setDiffCount)
        } else if (i < fromChildren.length) {
          // Node was removed
          result += wrapWithDeletion(fromChildren[i])
        } else {
          // Node was added
          result += wrapWithInsertion(toChildren[i])
        }
      }

      const attrsStr = toInfo.attrs ? ` ${toInfo.attrs}` : ''
      return `<${toInfo.tag}${attrsStr}>${result}</${toInfo.tag}>`
    }

    // Nodes are completely different
    let result = ''
    if (from.nodeType !== Node.COMMENT_NODE) {
      result += wrapWithDeletion(from)
    }
    if (to.nodeType !== Node.COMMENT_NODE) {
      result += wrapWithInsertion(to)
    }
    return result
  }

  // Handle body children
  const fromChildren = Array.from(fromNode.childNodes)
  const toChildren = Array.from(toNode.childNodes)

  let html = ''
  const maxLength = Math.max(fromChildren.length, toChildren.length)

  for (let i = 0; i < maxLength; i++) {
    if (i < fromChildren.length && i < toChildren.length) {
      html += compareNodes(fromChildren[i], toChildren[i], setDiffCount)
    } else if (i < fromChildren.length) {
      html += wrapWithDeletion(fromChildren[i])
    } else {
      html += wrapWithInsertion(toChildren[i])
    }
  }

  return html
}

function diffText(
  fromText: string,
  toText: string
): { html: string; count: number } {
  const diffs = diffWords(fromText, toText)

  let result = ''
  diffs.forEach((part) => {
    if (part.added) {
      console.log('added', part.value)
      result += `<ins>${part.value}</ins>`
    } else if (part.removed) {
      console.log('removed', part.value)
      result += `<delete>${part.value}</delete>`
    } else {
      console.log('no change', part.value)
      result += part.value
    }
  })

  console.log({
    count: diffs.reduce(
      (acc, part) => acc + (part.added || part.removed ? 1 : 0),
      0
    ),
    diffs,
  })

  return {
    html: result,
    count: diffs.reduce(
      (acc, part) => acc + (part.added || part.removed ? 1 : 0),
      0
    ),
  }
}

function wrapWithDeletion(node: Node): string {
  if (node.nodeType === Node.TEXT_NODE) {
    return `<delete>${node.textContent}</delete>`
  }
  if (node.nodeType === Node.ELEMENT_NODE) {
    const element = node as Element
    const outerHTML = element.outerHTML
    return `<delete>${outerHTML}</delete>`
  }
  return ''
}

function wrapWithInsertion(node: Node): string {
  if (node.nodeType === Node.TEXT_NODE) {
    return `<ins>${node.textContent}</ins>`
  }
  if (node.nodeType === Node.ELEMENT_NODE) {
    const element = node as Element
    const outerHTML = element.outerHTML
    return `<ins>${outerHTML}</ins>`
  }
  return ''
}

// Usage Example:
/*
import { Editor } from '@tiptap/core'
import StarterKit from '@tiptap/starter-kit'
import { DiffViewer } from './diff-viewer-extension'

const fromHTML = `
  <h1>Hello World</h1>
  <p>This is the original text.</p>
  <p>Another paragraph here.</p>
`

const toHTML = `
  <h1>Hello World!</h1>
  <p>This is the modified text.</p>
  <p>A new paragraph was added.</p>
  <p>Yet another one.</p>
`

const editor = new Editor({
  element: document.querySelector('#editor'),
  extensions: [
    StarterKit,
    DiffViewer.configure({
      fromHTML,
      toHTML,
    }),
  ],
})

// Or update diff dynamically:
editor.commands.setDiff(fromHTML, toHTML)
*/

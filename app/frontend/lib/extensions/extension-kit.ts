import {
  AiSuggestion,
  Blockquote,
  Color,
  Focus,
  FontFamily,
  Heading,
  Highlight,
  Link,
  Placeholder,
  SlashCommands,
  StarterKit,
  TableOfContents,
  TableOfContentsNode,
  TaskItem,
  TaskList,
  TextAlign,
  TextStyle,
  Typography,
  Underline,
  UniqueID,
} from '.'

export const editorExtensions = [
  StarterKit.configure({
    codeBlock: false,
    heading: false,
    horizontalRule: false,
    blockquote: false,
  }),
  Placeholder.configure({
    includeChildren: true,
    showOnlyCurrent: false,
    placeholder: () => '',
  }),
  Heading.configure({
    levels: [1, 2, 3, 4, 5, 6],
  }),
  Highlight.configure({ multicolor: true }),
  TaskList.configure({
    HTMLAttributes: {
      class: 'task-list',
    },
  }),
  TaskItem.configure({
    nested: true,
    HTMLAttributes: {
      class: 'task-item',
    },
  }),
  UniqueID.configure({
    types: ['paragraph', 'heading', 'blockquote', 'codeBlock', 'table'],
  }),
  TextAlign.extend({
    addKeyboardShortcuts() {
      return {}
    },
  }).configure({
    types: ['heading', 'paragraph'],
  }),
  Link.configure({
    autolink: true,
    defaultProtocol: 'https',
    linkOnPaste: true,
    shouldAutoLink: (url: string) => {
      return url.startsWith('http') || url.startsWith('https')
    },
    openOnClick: false,
    HTMLAttributes: {
      class: 'underline !font-normal',
    },
  }),
  Blockquote,
  SlashCommands,
  Focus,
  TextStyle,
  FontFamily,
  Typography,
  Color,
  AiSuggestion,
  TableOfContents,
  TableOfContentsNode,
  Underline,
]

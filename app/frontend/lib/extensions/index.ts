import { SlashCommands } from './slash-commands'
import Placeholder from '@tiptap/extension-placeholder'
import StarterKit from '@tiptap/starter-kit'
import Focus from '@tiptap/extension-focus'
import Heading from '@tiptap/extension-heading'

export const editorExtensions = [
  StarterKit.configure({
    codeBlock: false,
    heading: false,
    horizontalRule: false,
  }),
  Placeholder.configure({
    includeChildren: true,
    showOnlyCurrent: false,
    placeholder: () => '',
  }),
  Heading.configure({
    levels: [1, 2, 3, 4, 5, 6],
  }),
  SlashCommands,
  Focus,
]

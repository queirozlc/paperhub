import { SlashCommands } from './slash-commands'
import { HighlightedParagraph } from './highlight'
import Placeholder from '@tiptap/extension-placeholder'
import StarterKit from '@tiptap/starter-kit'

export const editorExtensions = [
  StarterKit.configure({
    codeBlock: false,
  }),
  Placeholder.configure({
    placeholder: ({ node }) => {
      if (node.type.name === 'paragraph') {
        return "Digite '/' para ver os comandos disponíveis"
      }

      return 'Comece escrevendo algo 🚀'
    },
  }),
  SlashCommands,
  HighlightedParagraph,
]

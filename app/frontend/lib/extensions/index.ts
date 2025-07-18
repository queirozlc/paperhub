import Placeholder from '@tiptap/extension-placeholder'
import StarterKit from '@tiptap/starter-kit'
import { Color } from '@tiptap/extension-color'
import TextStyle from '@tiptap/extension-text-style'
import Highlight from '@tiptap/extension-highlight'

import { SlashCommands } from './slash-commands'
import { Suggestion } from  './suggestion'
import { Diff } from './diff'

export const editorExtensions = [
  StarterKit.configure({ codeBlock: false, }),
  Placeholder.configure({
    placeholder: ({ node }) => {
      if (node.type.name === 'paragraph') {
        return "Digite '/' para ver os comandos disponíveis"
      }

      return 'Comece escrevendo algo 🚀'
    },
  }),
  SlashCommands,
  Color,
  TextStyle,
  Highlight.configure({ multicolor: true, }),
  Suggestion,
  Diff,
]

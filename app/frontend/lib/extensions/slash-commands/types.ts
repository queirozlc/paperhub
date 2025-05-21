import { Editor } from '@tiptap/core'

import { Icon } from '@lucide/svelte'

export interface Group {
  name: string
  title: string
  commands: Command[]
}

export interface Command {
  name: string
  label: string
  description: string
  shortcut?: string
  aliases?: string[]
  icon: typeof Icon
  action: (editor: Editor) => void
  shouldBeHidden?: (editor: Editor) => boolean
}

export interface MenuListProps {
  editor: Editor
  items: Group[]
  command: (command: Command) => void
}

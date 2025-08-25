import {
  Book,
  Heading1,
  Heading2,
  Heading3,
  Image,
  List,
  ListOrdered,
  ListTodo,
  Quote,
  Sparkles,
  SquareCode,
} from '@lucide/svelte'
import type { Editor } from '@tiptap/core'
import type { Group } from './types'
export const GROUPS: Group[] = [
  {
    name: 'ai',
    title: 'IA ✨',
    commands: [
      {
        name: 'aiWriter',
        label: 'Escreva com IA',
        icon: Sparkles,
        description: 'Deixe a IA completar seus pensamentos',
        shouldBeHidden: (editor: Editor) => editor.isActive('columns'),
        action: (editor: Editor) => editor.chain().focus().setAiWriter().run(),
      },
      {
        name: 'aiImage',
        label: 'Imagem IA',
        icon: Sparkles,
        description: 'Gerar uma imagem a partir do texto',
        shouldBeHidden: (editor: Editor) => editor.isActive('columns'),
        action: (editor: Editor) => editor.chain().focus().setAiImage().run(),
      },
    ],
  },
  {
    name: 'basic',
    title: 'Blocos Básicos',
    commands: [
      {
        name: 'heading1',
        label: 'Título 1',
        shortcut: '#',
        icon: Heading1,
        description: 'Título de seção de alta prioridade',
        aliases: ['h1'],
        action: (editor: Editor) => {
          editor.chain().focus().setHeading({ level: 1 }).run()
        },
      },
      {
        name: 'heading2',
        label: 'Título 2',
        shortcut: '##',
        icon: Heading2,
        description: 'Título de seção de média prioridade',
        aliases: ['h2'],
        action: (editor: Editor) => {
          editor.chain().focus().setHeading({ level: 2 }).run()
        },
      },
      {
        name: 'heading3',
        label: 'Título 3',
        shortcut: '###',
        icon: Heading3,
        description: 'Título de seção de baixa prioridade',
        aliases: ['h3'],
        action: (editor: Editor) => {
          editor.chain().focus().setHeading({ level: 3 }).run()
        },
      },
      {
        name: 'bulletList',
        label: 'Lista com Marcadores',
        icon: List,
        description: 'Lista não ordenada de itens',
        aliases: ['ul'],
        action: (editor: Editor) => {
          editor.chain().focus().toggleBulletList().run()
        },
      },
      {
        name: 'numberedList',
        label: 'Lista Numerada',
        icon: ListOrdered,
        description: 'Lista ordenada de itens',
        aliases: ['ol'],
        action: (editor: Editor) => {
          editor.chain().focus().toggleOrderedList().run()
        },
      },
      {
        name: 'taskList',
        label: 'Lista de Tarefas',
        icon: ListTodo,
        description: 'Lista de tarefas com itens para fazer',
        aliases: ['todo'],
        action: (editor: Editor) => {
          editor.chain().focus().toggleTaskList().run()
        },
      },
      {
        name: 'blockquote',
        label: 'Citação',
        icon: Quote,
        description: 'Elemento para citações',
        action: (editor: Editor) => {
          editor.chain().focus().setBlockquote().run()
        },
      },
      {
        name: 'codeBlock',
        label: 'Bloco de Código',
        icon: SquareCode,
        description: 'Bloco de código com destaque de sintaxe',
        //
        shouldBeHidden: () => true,
        action: (editor: Editor) => {
          editor.chain().focus().setCodeBlock().run()
        },
      },
    ],
  },
  {
    name: 'insert',
    title: 'Inserir',
    commands: [
      // {
      //   name: 'table',
      //   label: 'Tabela',
      //   icon: Table,
      //   description: 'Inserir uma tabela',
      //   shouldBeHidden: (editor: Editor) => editor.isActive('columns'),
      //   action: (editor: Editor) => {
      //     editor
      //       .chain()
      //       .focus()
      //       .insertTable({ rows: 3, cols: 3, withHeaderRow: false })
      //       .run()
      //   },
      // },
      {
        name: 'image',
        label: 'Imagem',
        icon: Image,
        description: 'Inserir uma imagem',
        aliases: ['img'],
        action: (editor: Editor) => {
          editor.chain().focus().setImageUpload().run()
        },
      },
      // {
      //   name: 'columns',
      //   label: 'Colunas',
      //   icon: Columns2,
      //   description: 'Adicionar conteúdo em duas colunas',
      //   aliases: ['cols'],
      //   shouldBeHidden: (editor: Editor) => editor.isActive('columns'),
      //   action: (editor: Editor) => {
      //     editor
      //       .chain()
      //       .focus()
      //       .setColumns()
      //       .focus(editor.state.selection.head - 1)
      //       .run()
      //   },
      // },
      // {
      //   name: 'horizontalRule',
      //   label: 'Linha Horizontal',
      //   icon: Minus,
      //   description: 'Inserir um divisor horizontal',
      //   aliases: ['hr'],
      //   action: (editor: Editor) => {
      //     editor.chain().focus().setHorizontalRule().run()
      //   },
      // },
      {
        name: 'toc',
        label: 'Sumário',
        icon: Book,
        aliases: ['outline'],
        description: 'Inserir um sumário',
        shouldBeHidden: (editor: Editor) => editor.isActive('columns'),
        action: (editor: Editor) => {
          editor.chain().focus().insertTableOfContents().run()
        },
      },
    ],
  },
]

export default GROUPS

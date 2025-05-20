<script lang="ts">
  import EditorLayout from '@/layouts/EditorLayout.svelte'
  import EditorFloatingMenu from '@/lib/components/editor-floating-menu.svelte'
  import SlashCommands from '@/lib/extensions/slash-commands/commands.svelte'
  import suggestion from '@/lib/extensions/slash-commands/suggestion.svelte'
  import Placeholder from '@tiptap/extension-placeholder'
  import StarterKit from '@tiptap/starter-kit'
  import { onMount } from 'svelte'
  import {
    BubbleMenu,
    createEditor,
    Editor,
    EditorContent,
    FloatingMenu,
  } from 'svelte-tiptap'
  import type { Readable } from 'svelte/store'
  import type { DocumentType } from './types'

  let { document }: { document: DocumentType } = $props()

  let editor = $state() as Readable<Editor>

  const docPladeholder = document.title || 'Sem título'

  onMount(() => {
    editor = createEditor({
      autofocus: true,
      editorProps: {
        attributes: {
          autocomplete: 'off',
          autocorrect: 'off',
          autocapitalize: 'off',
          class: 'prose dark:prose-invert focus:outline-none',
        },
      },
      content: ``,
      extensions: [
        StarterKit.configure({
          codeBlock: false,
        }),
        Placeholder.configure({
          placeholder: ({ node }) => {
            if (node.type.name === 'heading') {
              return docPladeholder
            }

            if (node.type.name === 'paragraph') {
              return "Digite '/' para ver os comandos disponíveis"
            }

            return 'Comece escrevendo algo 🚀'
          },
        }),
        SlashCommands.configure({
          suggestion,
        }),
      ],
    })
  })
</script>

<EditorLayout {document}>
  <div class="flex flex-col min-h-[calc(100svh-theme(spacing.4))]">
    <div
      class="border border-border px-20 py-16 size-full max-w-screen-md mx-auto"
    >
      <EditorContent editor={$editor} />
      {#if $editor}
        <FloatingMenu editor={$editor}>
          <EditorFloatingMenu {editor} />
        </FloatingMenu>
        <BubbleMenu editor={$editor} />
      {/if}
    </div>
  </div>
</EditorLayout>

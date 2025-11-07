<script lang="ts">
  import EditorLayout from '$layouts/EditorLayout.svelte'
  import { editorExtensions as extensions } from '$lib/extensions/extension-kit'
  import { onMount } from 'svelte'
  import ToolsBubbleMenu from '$lib/components/tools-bubble-menu.svelte'
  import { createEditor, Editor, EditorContent } from 'svelte-tiptap'
  import type { Readable } from 'svelte/store'
  import type { DocumentType } from './types'
  import LinkBubbleMenu from '$lib/components/link-bubble-menu.svelte'
  import { router } from '@inertiajs/svelte'
  import type { Editor as TiptapEditor } from '@tiptap/core'
  import { debounce } from '@tiptap/extension-table-of-contents'

  let { document }: { document: DocumentType } = $props()

  let editor = $state() as Readable<Editor>

  function updateDocument(editor: TiptapEditor) {
    router.patch(
      `/documents/${document.sqid}`,
      {
        document: { content: JSON.stringify(editor.getJSON()) },
      },
      {
        preserveScroll: true,
        preserveState: true,
      }
    )
  }

  onMount(() => {
    editor = createEditor({
      autofocus: true,
      editorProps: {
        attributes: {
          autocomplete: 'off',
          autocorrect: 'off',
          autocapitalize: 'off',
          class: '',
        },
      },
      content: document.content || '',
      onCreate({ editor }) {
        if (document.content) {
          editor.commands.setTextSelection(editor.state.doc.content.size)
        }
      },
      onUpdate: debounce(({ editor }) => updateDocument(editor), 500),
      extensions,
    })
  })
</script>

<EditorLayout {document} editor={$editor}>
  <div
    class=" min-h-[calc(100svh-theme(spacing.10))] border border-border px-12 py-16 w-full"
  >
    <EditorContent editor={$editor} />
    {#if $editor}
      <ToolsBubbleMenu editor={$editor} />
      <LinkBubbleMenu editor={$editor} />
    {/if}
  </div>
</EditorLayout>

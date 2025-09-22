<script lang="ts">
  import EditorLayout from '$layouts/EditorLayout.svelte'
  import { editorExtensions as extensions } from '$lib/extensions/extension-kit'
  import { onMount } from 'svelte'
  import ToolsBubbleMenu from '$lib/components/tools-bubble-menu.svelte'
  import { createEditor, Editor, EditorContent } from 'svelte-tiptap'
  import type { Readable } from 'svelte/store'
  import type { DocumentType } from './types'
  import LinkBubbleMenu from '$lib/components/link-bubble-menu.svelte'

  let { document }: { document: DocumentType } = $props()

  let editor = $state() as Readable<Editor>

  onMount(() => {
    editor = createEditor({
      autofocus: true,
      editorProps: {
        attributes: {
          autocomplete: 'off',
          autocorrect: 'off',
          autocapitalize: 'off',
          class: 'min-h-full relative',
        },
      },
      content: '',
      extensions,
    })
  })
</script>

<EditorLayout {document} editor={$editor}>
  <div class="flex flex-col min-h-[calc(100svh-theme(spacing.4))]">
    <div
      class="relative border border-border px-20 py-16 size-full max-w-screen-md mx-auto"
    >
      <EditorContent editor={$editor} />
      {#if $editor}
        <ToolsBubbleMenu editor={$editor} />
        <LinkBubbleMenu editor={$editor} />
      {/if}
    </div>
  </div>
</EditorLayout>

<script lang="ts">
  import EditorLayout from '$layouts/EditorLayout.svelte'
  import Separator from '$lib/components/ui/separator/separator.svelte'
  import { editorExtensions as extensions } from '$lib/extensions'
  import { onMount } from 'svelte'
  import {
    BubbleMenu,
    createEditor,
    Editor,
    EditorContent,
  } from 'svelte-tiptap'
  import type { Readable } from 'svelte/store'
  import type { DocumentType } from './types'

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
      content: ``,
      extensions,
    })
  })
</script>

<EditorLayout {document}>
  <div class="flex flex-col min-h-[calc(100svh-theme(spacing.4))] pb-5">
    <div
      class="border border-border px-20 bg-background-editor py-16 relative size-full max-w-screen-md mx-auto"
    >
      <EditorContent editor={$editor} />
      {#if $editor}
        <BubbleMenu
          class="bg-popover shadow-[1px_1px_4px_rgba(0,0,0,0.1)] p-1 rounded w-fit max-w-[90vw] overflow-hidden"
          tippyOptions={{
            placement: 'top-start',
          }}
          editor={$editor}
        >
          <div
            class="inline-flex gap-0.5 h-full items-center leading-none text-foreground"
          >
            <Separator
              orientation="vertical"
              class="h-full min-h-[1.5rem] w-px mx-1 first:ml-0 last:mr-0"
            />
            <button>italic</button>
          </div>
        </BubbleMenu>
      {/if}
    </div>
  </div>
</EditorLayout>

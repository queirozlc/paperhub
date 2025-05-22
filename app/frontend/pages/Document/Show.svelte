<script lang="ts">
  import EditorLayout from '@/layouts/EditorLayout.svelte'
  import { editorExtensions as extensions } from '@/lib/extensions'
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
          class: 'min-h-full',
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
      class="border border-border px-20 py-16 relative size-full max-w-screen-md mx-auto"
    >
      <EditorContent editor={$editor} class="flex-1" />
      {#if $editor}
        <BubbleMenu
          tippyOptions={{
            popperOptions: {
              placement: 'top-start',
              modifiers: [
                {
                  name: 'preventOverflow',
                  options: {
                    boundary: 'viewport',
                    padding: 8,
                  },
                },
                {
                  name: 'flip',
                  options: {
                    fallbackPlacements: [
                      'bottom-start',
                      'top-end',
                      'bottom-end',
                    ],
                  },
                },
              ],
            },
            offset: [0, 8],
            maxWidth: 'calc(100vw - 16px)',
          }}
          pluginKey="bubbleMenu"
          editor={$editor}
        ></BubbleMenu>
      {/if}
    </div>
  </div>
</EditorLayout>

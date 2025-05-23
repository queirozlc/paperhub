<script lang="ts">
  import EditorLayout from '$layouts/EditorLayout.svelte'
  import Separator from '$lib/components/ui/separator/separator.svelte'
  import Toggle from '$lib/components/ui/toggle/toggle.svelte'
  import { editorExtensions as extensions } from '$lib/extensions'
  import { BoldIcon } from '@lucide/svelte'
  import { onMount } from 'svelte'

  import {
    BubbleMenu,
    createEditor,
    Editor,
    EditorContent,
  } from 'svelte-tiptap'
  import type { Readable } from 'svelte/store'
  import type { DocumentType } from './types'
  import AiDropdown from '$lib/components/ai-dropdown.svelte'
  import ContentTypePicker from '$lib/components/content-type-picker.svelte'

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
          class="bg-background border border-input shadow-[1px_1px_4px_rgba(0,0,0,0.1)] p-1 rounded w-fit max-w-[90vw] overflow-hidden"
          tippyOptions={{
            placement: 'top-start',
            popperOptions: {
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
          editor={$editor}
        >
          <div
            class="inline-flex gap-0.5 h-full items-center leading-none text-foreground"
          >
            <AiDropdown editor={$editor} />

            <Separator
              orientation="vertical"
              class="h-full min-h-[1.5rem] w-px mx-1 first:ml-0 last:mr-0"
            />

            <ContentTypePicker editor={$editor} />

            <Separator
              orientation="vertical"
              class="h-full min-h-[1.5rem] w-px mx-1 first:ml-0 last:mr-0"
            />

            <Toggle
              size="sm"
              class="cursor-pointer"
              onclick={() => $editor.chain().toggleBold().run()}
            >
              <BoldIcon class="size-4" />
            </Toggle>
          </div>
        </BubbleMenu>
      {/if}
    </div>
  </div>
</EditorLayout>

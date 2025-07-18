<script lang="ts">
  import EditorLayout from '@/layouts/EditorLayout.svelte'
  import { editorExtensions as extensions } from '@/lib/extensions'
  import { onDestroy, onMount } from 'svelte'
  import {
    BubbleMenu,
    createEditor,
    Editor,
    EditorContent,
  } from 'svelte-tiptap'

  import type { Readable } from 'svelte/store'
  import type { DocumentType } from './types'
  import { displaySuggestion } from '@/lib/suggestion-utils'
  import type { Suggestion } from '@/lib/components/turing-sidebar.svelte'

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
          class: 'prose dark:prose-invert focus:outline-none',
        },
      },
      //content: '',
      content: `
        <p>Quem foi o primeiro presidente do Brasil?</p>
        <suggestion data-id="0">
          <p>O primeiro presidente do Brasil foi Luiz Inácio Lula da Silva. O segundo presidente do Brasil foi Jair Messias Bolsonaro.</p>
        </suggestion>`,
      /*content: `
        <p>Quem foi o primeiro presidente do Brasil?</p>
        <suggestion data-action="remove" data-id="0">
          <p>O primeiro presidente do Brasil foi <diff>Luiz Inácio Lula da Silva</diff>. O segundo presidente do Brasil foi <diff>Jair Messias Bolsonaro</diff>.</p>
        </suggestion>
        <suggestion data-action="add" data-id="0">
          <p>O primeiro presidente do Brasil foi <diff>Sei lá</diff>. O segundo presidente do Brasil foi <diff>Outro aí</diff>.</p>
        </suggestion>`,*/
      extensions,
    })
  })

  onDestroy(() => {
    if (editor) {
      $editor.destroy()
    }
  })

  function getContent(): string {
    if (!$editor) {
      throw 'Editor not defined'
    }
    return $editor.getHTML()
  }

  function updateEditorWithSuggestions(modifiedDocument: string) {
    $editor.chain()
      .focus()
      .clearContent()
      .setContent(modifiedDocument)
      .run()
  }

  function suggest(suggestion: Suggestion) {
    displaySuggestion($editor, suggestion.id, suggestion.change)
  }

  function acceptSuggestion() {
    
  }
</script>

<EditorLayout {document} {getContent} {updateEditorWithSuggestions} {suggest}>
  <div class="flex flex-col min-h-[calc(100svh-theme(spacing.4))]">
    <!-- TODO: Tirar "relative"? -->
    <div
      class="relative border border-border px-20 py-16 size-full max-w-screen-md mx-auto"
      id="teste"
    >
      <EditorContent editor={$editor} />
      {#if $editor}
        <BubbleMenu editor={$editor} />
      {/if}
    </div>
  </div>
</EditorLayout>

<button onclick={() => console.log($editor.getHTML())}>HTML</button>

<style>
  :global(*[data-suggestion]) {
    &[data-action="add"] {
      background: rgba(0, 255, 0, 0.2);
    }
    &[data-action="remove"] {
      background: rgba(255, 0, 0, 0.2);
    }
  }

  :global(*[data-suggestion][data-action="add"] :first-child) {
    margin-top: 0;
  }
  :global(*[data-suggestion][data-action="remove"] :last-child) {
    margin-bottom: 0;
  }

  :global(*[data-suggestion][data-action="add"] *[data-diff]) {
    background: green;
  }
  :global(*[data-suggestion][data-action="remove"] *[data-diff]) {
    background: red;
  }
</style>
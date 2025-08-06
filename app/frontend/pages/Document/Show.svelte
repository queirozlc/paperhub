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
  import { extractNodeHtmlContent, highlightHtmllDifferences } from '@/lib/suggestion-utils'
  import type { Suggestion } from '@/lib/components/turing-sidebar.svelte'
  import type { Node as NodeType } from "@tiptap/pm/model";

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
      content: '',
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

  function replaceEditorContent(modifiedDocument: string) {
    $editor.chain()
      .focus()
      .clearContent()
      .setContent(modifiedDocument)
      .run()
  }

  function suggest(suggestion: Suggestion) {
    let node: NodeType
    let diff: { original: string, suggestion: string } = null

    $editor.chain()
      .focus()
      .selectSuggestion({ "data-id": suggestion.id, "data-action": null })
      .command(({ tr }) => {
        const { selection } = tr

        if (selection.empty) {
          throw 'Sugestão não pode ser exibida pois já está sendo exibida ou já foi aprovada'
        }

        const pos = selection.from
        node = tr.doc.nodeAt(pos);

        const htmlContent = extractNodeHtmlContent(node)
        const [ originalDiff, suggestionDiff ] = highlightHtmllDifferences(htmlContent, suggestion.change)
        diff = {
          original: originalDiff,
          suggestion: suggestionDiff
        }

        return true
      })
      .updateSuggestion(
        {
          ...node.attrs,
          "data-action": "remove",
          "data-empty": diff.original.length === 0,
          "data-empty-brother": diff.suggestion.length === 0
        },
        diff.original
      )
      .addSuggestionBellow(
        {
          ...node.attrs,
          "data-action": "add",
          "data-empty": diff.suggestion.length === 0,
          "data-empty-brother": diff.original.length === 0
        },
        diff.suggestion
      )
      .run()
  }
</script>

<EditorLayout {document} {getContent} {replaceEditorContent} {suggest}>
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

<button onclick={() => console.log($editor.getJSON())}>Nodes</button>

<button onclick={() => console.log($editor.getHTML())}>HTML</button>
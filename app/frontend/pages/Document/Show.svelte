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
      content: `<h1>Documento do Bruno</h1><p>Este é um documento de <span data-hover-mark>teste</span>.</p>`,
      extensions,
    })
  })

  onDestroy(() => {
    if (editor) {
      $editor.destroy()
    }
  })

  function suggest(i: number, j: number, replaceText: string) {
    console.log("Suggest")
    /*$editor.chain()
      .focus()
      .insertContentAt({ from: 4, to: 8 }, replaceText)
      .run()
    */

    let posicaoInicio = null;
    let posicaoFim = null;
    let contadorIndex = 0;

    $editor.state.doc.descendants((node, pos) => {
      if (node.isText) {
        const nodeText = node.text;
        const iNodeText = contadorIndex;
        const jNodeText = contadorIndex + nodeText.length;

        // Verifica se o índice inicial está neste nó de texto
        if (posicaoInicio === null && i >= iNodeText && i <= jNodeText) {
          posicaoInicio = pos + (i - iNodeText);
        }

        // Verifica se o índice final está neste nó de texto
        if (posicaoFim === null && j >= iNodeText && j <= jNodeText) {
          posicaoFim = pos + (j - iNodeText);
        }

        contadorIndex += nodeText.length;
      } else if (node.isBlock) {
        // Adiciona quebra de linha para blocos (como parágrafos)
        contadorIndex += 1;
      }
    })

    if (posicaoInicio !== null && posicaoFim !== null) {
      $editor.chain()
        .focus()
        .setTextSelection({ from: posicaoInicio, to: posicaoFim })
        .insertContent(replaceText)
        .run();
    }
  }
</script>

<EditorLayout {document}>
  <div class="flex flex-col min-h-[calc(100svh-theme(spacing.4))]">
    <div
      class="border border-border px-20 py-16 size-full max-w-screen-md mx-auto"
    >
      <EditorContent editor={$editor} />
      {#if $editor}
        <BubbleMenu editor={$editor} />
      {/if}
    </div>
  </div>
</EditorLayout>

<button onclick={() => console.log($editor)}>$editor</button>

<button onclick={() => console.log($editor.getJSON())}>JSON</button>

<button onclick={() => console.log($editor.getHTML())}>HTML</button>

<button onclick={() => suggest(30, 39, "TESTE")}>Teste</button>

<style>
  :global(span[data-hover-mark]) {
    color: var(--primary);
    background: rgba(0, 255, 0, 0.2);
  }

  :global(span[data-hover-mark]:hover) {
    color: yellow;
  }
</style>
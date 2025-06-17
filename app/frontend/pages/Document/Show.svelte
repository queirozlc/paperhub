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

  export type Suggestion = {
    text: string,
    action: "add" | "replace" | "delete",
    from: number | null,
    to: number,
    explanation: string
  }

  let { document }: { document: DocumentType } = $props()

  let editor = $state() as Readable<Editor>

  // let currentButton: HTMLButtonElement | null = null;

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
      //content: '<p>O primeiro presidente do Brasil foi Luiz Inácio Lula da Silva.</p>',
      content: '<p>Quem foi o primeiro presidente do Brasil?</p><p>O primeiro presidente do Brasil foi Luiz Inácio Lula da Silva.</p>',
      //content: `<h1>Documento do Bruno</h1><p>O primeiro presidente do Brasil foi <span data-hover-mark>Luiz Inácio Lula da Silva</span>.</p>`,
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
      return ''
    }
    return $editor.getHTML()
  }

  function suggest(suggestion: Suggestion) {
    console.log("Suggestion:", suggestion)

    if (!$editor) {
      return
    }

    const { action, from: i, to: j, text } = suggestion
    const { from, to } = getRealIndexes(i ?? 0, j)

    const chain = $editor.chain().focus()

    switch (action) {
      case 'add':
        chain.insertContentAt(to, text)
        break
      case 'replace':
        chain.setTextSelection({ from, to })
          .insertContent(text)
        break
      case 'delete':
        chain.setTextSelection({ from, to }).deleteSelection()
        break
      default:
        console.warn('Ação desconhecida:', action)
        return
    }

    chain.run()
  }

  function getRealIndexes(i: number, j: number) {
    let from = null;
    let to = null;
    let contadorIndex = 0;

    $editor.state.doc.descendants((node, pos) => {
      if (node.isText) {
        const nodeText = node.text;
        const iNodeText = contadorIndex;
        const jNodeText = contadorIndex + nodeText.length;

        // Verifica se o índice inicial está neste nó de texto
        if (from === null && i >= iNodeText && i <= jNodeText) {
          from = pos + (i - iNodeText);
        }

        // Verifica se o índice final está neste nó de texto
        if (to === null && j >= iNodeText && j <= jNodeText) {
          to = pos + (j - iNodeText);
        }

        contadorIndex += nodeText.length;
      } else if (node.isBlock) {
        // Adiciona quebra de linha para blocos (como parágrafos)
        contadorIndex += 1;
      }
    })

    return { from, to }
  }

  function suggestTeste(i: number, j: number, replaceText: string) {
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

  /*
  function addButtonAndMarkTest() {
    const id = `mark-${incrementalMarkId++}`;
    $editor
      .chain()
      .focus()
      .insertContentAt($editor.state.doc.content.size, [
        {
          type: 'text',
          text: "AAAAA",
          marks: [{ type: 'hoverMark', attrs: { id }}],
        },
      ])
      .run();

    setTimeout(() => {
      addButtonTest(id);
    }, 100);
  }

  function addButtonTest(markId: string) {
    const mark = window.document.getElementById(markId) as HTMLElement
    const markRect = mark.getBoundingClientRect();

    const btn = window.document.createElement('button');
    btn.textContent = 'Ação';
    btn.className = 'mark-btn';
    btn.onclick = () => alert('Botão clicado!');

    //btn.style.top = `${markRect.top}px`;
    //btn.style.left = `${markRect.left}px`;
    //window.document.getElementById('teste').appendChild(btn);

    mark.appendChild(btn)
  }
  */
</script>

<EditorLayout {document} {getContent} {suggest}>
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

<button onclick={() => console.log($editor)}>$editor</button>

<button onclick={() => console.log($editor.getJSON())}>JSON</button>

<button onclick={() => console.log($editor.getHTML())}>HTML</button>

<button onclick={() => suggestTeste(1, 10, "TESTE")}>Alterar</button>

<!--<button onclick={() => addButtonAndMarkTest()}>
  AddTexto
</button>-->

<style>
  :global(span[data-hover-mark]) {
    position: relative;
    color: var(--primary);
    background: rgba(0, 255, 0, 0.2);
  }

  :global(span[data-hover-mark]:hover) {
    color: yellow;
  }

  /*
  :global(.hover-mark-span) {
    position: relative;
    background: #ffffcc;
  }

  :global(.hover-mark-btn) {
    display: none;
    position: absolute;
    top: -30px;
    right: 0;
    z-index: 10;
    background: #333;
    color: #fff;
    border: none;
    border-radius: 4px;
    padding: 2px 8px;
    cursor: pointer;
  }

  :global(.hover-mark-span:hover .hover-mark-btn) {
    display: inline-block;
  }
  */
</style>
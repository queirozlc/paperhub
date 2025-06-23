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
  import { diffWords } from 'diff' //! TODO: Remover lib
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
      content: '<p>Quem foi o primeiro presidente do Brasil?</p><p>O primeiro presidente do Brasil foi Luiz Inácio Lula da Silva.</p>',
      //content: `<h1>Documento do Bruno</h1><p>O primeiro presidente do Brasil foi <span data-hover-mark>Luiz Inácio Lula da Silva</span>.</p>`,
      //content: `<h1>Documento do Bruno</h1><p>O <span data-suggestion>primeiro</span> presidente do Brasil foi <mark>Luiz Inácio Lula da Silva</mark>.</p>`,
      /*content: `
        <h1>Olá Bruno</h1>
        <p>Isto é uma <span data-suggestion data-id='0'>sugestão</span></p>
        <p>Isto é outra <span data-suggestion data-id='1'>sugestão</span> e aqui vai <span data-suggestion data-id='2'>mais uma</span> só</p>
      `,*/
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

  function updateEditorWithSuggestions(modifiedDocument: string, nextSuggestionIndex: number) {
    const parser = new DOMParser()
    const doc = parser.parseFromString(modifiedDocument, "text/html")

    // 2. Localiza todos os spans que possuem o atributo "data-suggestion"
    //    mas que NÃO possuem o atributo "data-id".
    //    A query CSS 'span[data-suggestion]:not([data-id])' faz essa seleção de forma precisa.
    const seletor = 'span[data-suggestion]:not([data-id])';
    const spansEncontrados: NodeListOf<HTMLSpanElement> = doc.querySelectorAll(seletor);

    if (spansEncontrados.length === 0) {
      return
    }

    spansEncontrados.forEach(span => {
      const idx = parseInt(span.getAttribute('data-idx'))
      span.setAttribute('data-id', nextSuggestionIndex + idx + '')
    });

    spansEncontrados.forEach(span => {
      const idx = parseInt(span.getAttribute('data-idx'))
    })

    $editor.chain()
      .focus()
      .clearContent()
      .setContent(doc.documentElement.outerHTML)
      .run()
  }

  function suggest(suggestion: Suggestion) {

    // 1. Buscar o span com data-suggestion e data-id igual a suggestionId
    const suggestionSpan = $editor.view.dom.querySelector(
      `span[data-suggestion][data-id="${suggestion.id}"]`
    ) as HTMLSpanElement;

    if (!suggestionSpan) {
      console.warn(`Sugestão com ID ${suggestion.id} não encontrada`);
      return;
    }

    // 2. Obter o elemento pai do span
    const parentElement = suggestionSpan.parentElement;
    if (!parentElement) {
      console.warn('Elemento pai não encontrado');
      return;
    }

    // 3. Pintar o conteúdo do span de vermelho escuro
    suggestionSpan.style.color = 'red'; // Vermelho escuro
    suggestionSpan.style.backgroundColor = '#FFE4E1'; // Fundo claro para contraste

    // 4. Adicionar atributo data-suggestion-type='delete' ao elemento pai
    parentElement.setAttribute('data-suggestion-type', 'delete');

    // 5. Duplicar o elemento pai
    const clonedElement = parentElement.cloneNode(true) as HTMLElement;

    // 6. Adicionar atributo data-suggestion-type='add' ao clone
    clonedElement.setAttribute('data-suggestion-type', 'add');

    // 7. No clone, pintar o texto que era circundado por span de verde escuro
    const clonedSuggestionSpan = clonedElement.querySelector(
      `span[data-suggestion][data-id="${suggestion.id}"]`
    ) as HTMLSpanElement;

    if (clonedSuggestionSpan) {
      // Substituir o span pela versão com texto verde
      const textContent = clonedSuggestionSpan.textContent || '';
      const greenSpan = window.document.createElement('span');
      greenSpan.textContent = textContent;
      greenSpan.style.color = 'green'; // Verde escuro
      greenSpan.style.backgroundColor = '#E8F5E8'; // Fundo verde claro
      greenSpan.setAttribute('data-suggestion-accepted', 'true');
      greenSpan.textContent = suggestion.text; // Atualizar o texto do span
      
      clonedSuggestionSpan.replaceWith(greenSpan);
    }

    // Inserir o clone após o elemento original
    parentElement.insertAdjacentElement('afterend', clonedElement);

    // Atualizar o conteúdo do editor TipTap
    const updatedHTML = $editor.view.dom.innerHTML;
    $editor.commands.setContent(updatedHTML, false);
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

<style>
  :global(*[data-suggestion-type='add']) {
    background: rgba(0, 255, 0, 0.2);
    margin-top: 0;
  }

  :global(*[data-suggestion-type='delete']) {
    background: rgba(255, 0, 0, 0.2);
    margin-bottom: 0;
  }
</style>
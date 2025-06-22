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

  export type Suggestion = {
    originalText: string,
    suggestedText: string,
    action: "add" | "replace" | "delete",
    explanation: string,
  }

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
      //cotent: '<p>O primeiro presidente do Brasil foi Luiz Inácio Lula da Silva.</p>',
      //content: '<p>Quem foi o primeiro presidente do Brasil?</p><p>O primeiro presidente do Brasil foi Luiz Inácio Lula da Silva.</p>',
      //content: `<h1>Documento do Bruno</h1><p>O primeiro presidente do Brasil foi <span data-hover-mark>Luiz Inácio Lula da Silva</span>.</p>`,
      //content: `<h1>Documento do Bruno</h1><p>O <span data-suggestion>primeiro</span> presidente do Brasil foi <mark>Luiz Inácio Lula da Silva</mark>.</p>`,
      content: `
        <h1>Olá Bruno</h1>
        <p>Isto é uma <span data-suggestion data-id='0'>sugestão</span></p>
        <p>Isto é outra <span data-suggestion data-id='1'>sugestão</span> e aqui vai <span data-suggestion data-id='2'>mais uma</span> só</p>
      `,
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

  /*
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
  */



  /*
  function processAndLoadHtml(htmlString) {
    if (!$editor || !htmlString) {
      console.warn("Editor não inicializado ou HTML de entrada vazio.");
      return;
    }

    const suggestions: Suggestion[] = [
      {
        originalText: 'AAA',
        suggestedText: 'BBB',
        action: 'replace',
        explanation: 'asdsadsadasd',
      }, {
        originalText: 'CCC',
        suggestedText: 'DDD',
        action: 'replace',
        explanation: 'asdsadsadasd',
      }, {
        originalText: 'EEE',
        suggestedText: 'FFF',
        action: 'replace',
        explanation: 'asdsadsadasd',
      },
    ];

    // 1. Usamos o DOMParser para converter a string HTML em um documento DOM manipulável.
    // Isso é muito mais seguro e robusto do que usar Regex para manipular HTML.
    const parser = new DOMParser();
    const doc = parser.parseFromString(htmlString, 'text/html');
    const body = doc.body;

    // 2. Encontramos todos os elementos que contêm o padrão "{{int}}".
    // Usamos `querySelectorAll` e depois filtramos para garantir que estamos
    // pegando o elemento mais interno que contém o texto.
    const testRegex = /{{\d+}}/;
    const replaceRegex = /{{(\d+)}}/;
    const candidates = Array.from(body.querySelectorAll('*'));

    // Iteramos de trás para frente para evitar problemas ao modificar o DOM
    // enquanto o percorremos (ex: o índice dos nós muda).
    for (let i = candidates.length - 1; i >= 0; i--) {
      const originalElement = candidates[i];

      console.log('Candidato:')
      console.log(originalElement);
      
      const containSuggestion = testRegex.test(originalElement.innerHTML)

      if (containSuggestion) {
        // 3. Ao encontrar um elemento, clonamos ele completamente.
        const cloneElement = originalElement.cloneNode(true) as Element;

        originalElement.innerHTML = originalElement.innerHTML.replace(
          replaceRegex,
          (match, n) => {
            const suggestionIndex = parseInt(n)
            const suggestion = suggestions[suggestionIndex]
            return suggestion.originalText;
          }
        );

        // 3. Fazemos o mesmo para o elemento clonado, com um texto diferente
        cloneElement.innerHTML = cloneElement.innerHTML.replace(
          replaceRegex,
          (match, n) => {
            const suggestionIndex = parseInt(n)
            const suggestion = suggestions[suggestionIndex]
            return suggestion.suggestedText;
          }
        );

        // 5. Inserimos o elemento clonado logo após o original no DOM.
        originalElement.parentNode.insertBefore(cloneElement, originalElement.nextSibling);
      }
    }

    // 6. Pegamos o HTML final do corpo do nosso documento temporário.
    const finalHtml = body.innerHTML;

    // 7. Atualizamos o conteúdo do TipTap com o resultado.
    $editor.commands.setContent(finalHtml);
  }
  */


  // !!!!!
  /*
  function processSuggestionWithAttributes(suggestionId: number) {
		if (!editor) {
      return;
    }

		let parentPos: number | null = null;
		//let parentNode: ProseMirrorNode | null = null;
    let parentNode: ProseMirrorNode | null = null;
		
		// 1. Encontra o nó pai da sugestão (lógica idêntica à anterior)
		$editor.state.doc.descendants((node, pos) => {
			if (node.isText) {
				const suggestionMark = node.marks.find(
					mark => mark.type.name === 'suggestion' && Number(mark.attrs.id) === suggestionId
				);

				if (suggestionMark) {
					const resolvedPos = $editor.state.doc.resolve(pos);
					parentNode = resolvedPos.parent;
					parentPos = resolvedPos.start(resolvedPos.depth);
					return false;
				}
			}
		});

		if (parentNode === null || parentPos === null) {
			alert(`Sugestão com ID ${suggestionId} não encontrada.`);
			return;
		}

		// 2. Inicia a transação
		let tr = $editor.state.tr;

    console.log('A')

		// 3. Adiciona `data-suggestion-type='delete'` ao parágrafo pai original
		tr = tr.setNodeMarkup(parentPos, undefined, { 
			...parentNode.attrs, 
			suggestionType: 'delete'
		});

    console.log('B')

		// 4. Cria um novo nó para o clone com `data-suggestion-type='add'`
		const clonedNode = $editor.schema.nodes.paragraph.create(
			{ ...parentNode.attrs, suggestionType: 'add' }, // Atributos do clone
			parentNode.content // Conteúdo é o mesmo do original
		);

    console.log('C')
		
		// 5. Insere o clone logo após o original
		const insertPos = parentPos + parentNode.nodeSize;
		tr = tr.insert(insertPos, clonedNode);
		
		// 6. Aplica a transação
		$editor.view.dispatch(tr);
		$editor.commands.focus();
	}
  */

  function processSuggestionWithAttributes(suggestionId: number) {
    const suggestions: Suggestion[] = [
      {
        originalText: 'AAA',
        suggestedText: 'BBB',
        action: 'replace',
        explanation: 'asdsadsadasd',
      }, {
        originalText: 'CCC',
        suggestedText: 'DDD',
        action: 'replace',
        explanation: 'asdsadsadasd',
      }, {
        originalText: 'EEE',
        suggestedText: 'FFF',
        action: 'replace',
        explanation: 'asdsadsadasd',
      },
    ];

    // 1. Buscar o span com data-suggestion e data-id igual a suggestionId
    const suggestionSpan = $editor.view.dom.querySelector(
      `span[data-suggestion][data-id="${suggestionId}"]`
    ) as HTMLSpanElement;

    const suggestion = suggestions[suggestionId] || null;

    if (!suggestionSpan || !suggestion) {
      console.warn(`Sugestão com ID ${suggestionId} não encontrada`);
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
      `span[data-suggestion][data-id="${suggestionId}"]`
    ) as HTMLSpanElement;

    if (clonedSuggestionSpan) {
      // Substituir o span pela versão com texto verde
      const textContent = clonedSuggestionSpan.textContent || '';
      const greenSpan = window.document.createElement('span');
      greenSpan.textContent = textContent;
      greenSpan.style.color = 'green'; // Verde escuro
      greenSpan.style.backgroundColor = '#E8F5E8'; // Fundo verde claro
      greenSpan.setAttribute('data-suggestion-accepted', 'true');
      greenSpan.textContent = suggestion.suggestedText; // Atualizar o texto do span
      
      clonedSuggestionSpan.replaceWith(greenSpan);
    }

    // Inserir o clone após o elemento original
    parentElement.insertAdjacentElement('afterend', clonedElement);

    // Atualizar o conteúdo do editor TipTap
    const updatedHTML = $editor.view.dom.innerHTML;
    $editor.commands.setContent(updatedHTML, false);
  }
</script>

<EditorLayout {document} {getContent} suggest={(a) => {}}> <!--{suggest}-->
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

<button onclick={() => processSuggestionWithAttributes(2)}>Suggest</button>

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
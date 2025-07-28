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
  import { displaySuggestion, getSuggestionNodesById, type NodeData } from '@/lib/suggestion-utils'
  import type { Suggestion } from '@/lib/components/turing-sidebar.svelte'
  import type { Node } from "@tiptap/pm/model";

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
        <p>paragrafo simples</p>
        <p>remover <diff>este</diff> e <diff>este outro</diff> marks</p>`,*/
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
    displaySuggestion($editor, suggestion.id, suggestion.change)
  }

  /*function removeDiffs() {
    const nodes = getSuggestionNodesById($editor, 0, 'both')
    const tc = nodes[0].node.textContent 
    removeDiffsFromNode(nodes[0])
  }*/

  /*function removeDiffsFromNode(data: NodeData) {
    const nodesToRemove = []
      
    data.node.descendants((childNode, childPos) => {
      if (childNode.type.name === 'diff') {
        nodesToRemove.push({
          node: childNode,
          pos: data.pos.init + childPos + 1 // +1 para ajustar a posição relativa
        })
      }
    })

    // Remove os nós diff de trás para frente para manter as posições corretas
    nodesToRemove.reverse().forEach(({ node: diffNode, pos: diffPos }) => {
      // Se o nó diff tem conteúdo, substitui o nó pelos seus filhos
      if (diffNode.content.size > 0) {
        tr.replaceWith(diffPos, diffPos + diffNode.nodeSize, diffNode.content)
      } else {
        // Se não tem conteúdo, apenas remove o nó
        tr.delete(diffPos, diffPos + diffNode.nodeSize)
      }
      modified = true
    })
  }*/

  function aaa(suggestionId: number) {
    const { tr } = $editor.state
    let modified = false

    // Percorre todo o documento em busca dos nós com os atributos especificados
    $editor.state.doc.descendants((node, pos) => {
      console.log(node)
      console.log(pos)

      // Verifica se o nó possui os atributos data-suggestion e data-id
      if (node.type.name === 'suggestion'
      &&  node.attrs['data-id'] === suggestionId) {

        // Encontra e remove todos os nós do tipo "diff" dentro deste nó
        const nodesToRemove = []
        
        node.descendants((childNode, childPos) => {
          if (childNode.type.name === 'diff') {
            nodesToRemove.push({
              node: childNode,
              pos: pos + childPos + 1 // +1 para ajustar a posição relativa
            })
          }
        })

        // Remove os nós diff de trás para frente para manter as posições corretas
        /*nodesToRemove.reverse().forEach(({ node: diffNode, pos: diffPos }) => {
          // Se o nó diff tem conteúdo, substitui o nó pelos seus filhos
          if (diffNode.content.size > 0) {
            tr.replaceWith(diffPos, diffPos + diffNode.nodeSize, diffNode.content);
          } else {
            // Se não tem conteúdo, apenas remove o nó
            tr.delete(diffPos, diffPos + diffNode.nodeSize);
          }
          modified = true;
        });*/
      }
    });

    // Aplica as mudanças se houve modificações
    if (modified) {
      $editor.view.dispatch(tr);
    }
  }

  function acceptSuggestion(suggestionId: number) {
    //aaa(0)
    $editor.chain()
      .focus()
      .selectSuggestion({ "data-id": suggestionId, "data-action": "remove" })
      .removeDiffsFromSelected()
      .deleteSelection() // Deletes "remove" suggestion
      .selectSuggestion({ "data-id": suggestionId, "data-action": "add" })
      .removeDiffsFromSelected()
      .removeSelectedSuggestionContainer()
      .run()
  }

  function refuseSuggestion(suggestionId: number) {
    $editor.chain()
      .focus()
      .selectSuggestion({ "data-id": suggestionId, "data-action": "remove" })
      .removeDiffsFromSelected()
      .removeSelectedSuggestionContainer()
      .selectSuggestion({ "data-id": suggestionId, "data-action": "add" })
      .removeDiffsFromSelected()
      .deleteSelection() // Deletes "add" suggestion
      .run()
  }

  function keepBothFromSuggestion(suggestionId: number) {
    $editor.chain()
      .focus()
      .selectSuggestion({ "data-id": suggestionId, "data-action": "remove" })
      .removeDiffsFromSelected()
      .removeSelectedSuggestionContainer()
      .selectSuggestion({ "data-id": suggestionId, "data-action": "add" })
      .removeDiffsFromSelected()
      .removeSelectedSuggestionContainer()
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

<button onclick={() => acceptSuggestion(0)}>Accept</button>

<button onclick={() => refuseSuggestion(0)}>Refuse</button>

<button onclick={() => keepBothFromSuggestion(0)}>Both</button>

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
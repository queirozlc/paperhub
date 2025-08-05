<script lang="ts">
  import type { Editor } from "@tiptap/core"
  import type { Node } from "@tiptap/pm/model"
  import { NodeViewContent, NodeViewWrapper } from "svelte-tiptap"
  import { twMerge } from "tailwind-merge"

  // Props passadas automaticamente pelo SvelteNodeViewRenderer
  export let node: Node;
  export let editor: Editor;
  export let getPos;

  // Em Svelte, uma variável 'let' já é reativa dentro do componente.
  let isHovered = false;

  function acceptSuggestion() {
    const suggestionId = node.attrs["data-id"]
    editor.chain()
      .focus()
      .selectSuggestion({ "data-id": suggestionId, "data-action": "remove" })
      .removeDiffsFromSelected()
      .deleteSelection() // Deletes "remove" suggestion
      .selectSuggestion({ "data-id": suggestionId, "data-action": "add" })
      .removeDiffsFromSelected()
      .removeSelectedSuggestionContainer() // Removes all the suggestion container. This prevents a suggestion from being displayed again.
      .run()
  }

  function refuseSuggestion() {
    const suggestionId = node.attrs["data-id"]
    editor.chain()
      .focus()
      .selectSuggestion({ "data-id": suggestionId, "data-action": "remove" })
      .removeDiffsFromSelected()
      .removeActionFromSelected() // Just remove "action" property. This allows a suggestion to be displayed again. 
      .selectSuggestion({ "data-id": suggestionId, "data-action": "add" })
      .removeDiffsFromSelected()
      .deleteSelection() // Deletes "add" suggestion
      .run()
  }

  function keepBothFromSuggestion() {
    const suggestionId = node.attrs["data-id"]
    editor.chain()
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

<NodeViewWrapper
  data-suggestion
  {...node.attrs}
  class="relative data-[action=add]:bg-green-900 data-[action=remove]:bg-red-900 px-0.5 rounded data-action:border-2"
  onmouseenter={() => isHovered = true }
  onmouseleave={() => isHovered = false}
>
  {#if !!node.attrs["data-action"] && isHovered}
    <div class={twMerge(
      "absolute z-10 left-0 flex gap-1 border-b-white/5",
      node.attrs["data-action"] === "add"
        ? "-bottom-7 border-b-2"
        : "-top-7 border-t-2"
    )}>
      <button
        on:click={acceptSuggestion}
        contenteditable="false"
        class="text-green-500 px-1 cursor-pointer transition hover:bg-white/5"
      >
        Aceitar
      </button>
      <button
        on:click={refuseSuggestion}
        contenteditable="false"
        class="text-red-500 px-1 cursor-pointer transition hover:bg-white/5"
      >
        Recusar
      </button>
      <button
        on:click={keepBothFromSuggestion}
        contenteditable="false"
        class="text-orange-400 px-1 cursor-pointer transition hover:bg-white/5"
      >
        Manter ambas
      </button>
    </div>
  {/if}
  
  <NodeViewContent contenteditable={!node.attrs["data-action"]} />
</NodeViewWrapper>

<!-- TODO: Avaliar melhoria na estrutura do CSS -->

<style>
  :global(*[data-suggestion] :first-child) {
    margin-top: 0;
  }
  :global(*[data-suggestion] :last-child) {
    margin-bottom: 0;
  }

  :global(*[data-suggestion][data-action="add"] *[data-diff]) {
    background: rgba(0, 128, 0, 0.75);
  }
  :global(*[data-suggestion][data-action="remove"] *[data-diff]) {
    background: rgba(255, 0, 0, 0.75);
  }
</style>
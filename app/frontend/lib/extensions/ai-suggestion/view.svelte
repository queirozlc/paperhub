<script lang="ts">
  import { cn } from '$lib/utils'
  import type { NodeViewProps } from '@tiptap/core'
  import { NodeViewContent, NodeViewWrapper } from 'svelte-tiptap'

  let { node, editor }: NodeViewProps = $props()

  let isHovered = $state(false)

  function acceptSuggestion() {
    const suggestionId = node.attrs['data-id']
    editor
      .chain()
      .focus()
      .selectAiSuggestion({ 'data-id': suggestionId, 'data-action': 'remove' })
      .removeDiffsFromSelected()
      .deleteSelection()
      .selectAiSuggestion({ 'data-id': suggestionId, 'data-action': 'add' })
      .removeDiffsFromSelected()
      .removeSelectedAiSuggestionContainer()
      .run()
  }

  function refuseSuggestion() {
    const suggestionId = node.attrs['data-id']
    editor
      .chain()
      .focus()
      .selectAiSuggestion({ 'data-id': suggestionId, 'data-action': 'remove' })
      .removeDiffsFromSelected()
      .removeActionFromSelected()
      .selectAiSuggestion({ 'data-id': suggestionId, 'data-action': 'add' })
      .removeDiffsFromSelected()
      .deleteSelection()
      .run()
  }

  function keepBothFromSuggestion() {
    const suggestionId = node.attrs['data-id']
    editor
      .chain()
      .focus()
      .selectAiSuggestion({ 'data-id': suggestionId, 'data-action': 'remove' })
      .removeDiffsFromSelected()
      .removeSelectedAiSuggestionContainer()
      .selectAiSuggestion({ 'data-id': suggestionId, 'data-action': 'add' })
      .removeDiffsFromSelected()
      .removeSelectedAiSuggestionContainer()
      .run()
  }
</script>

<NodeViewWrapper
  data-ai-suggestion
  {...node.attrs}
  class={cn(
    'relative data-[action=add]:bg-suggestion-accept-background data-[action=remove]:bg-suggestion-reject-background data-[action]:px-0.5 rounded data-action:border-2',
    { hidden: node.attrs['data-empty'] },
    { 'my-5': node.attrs['data-empty-brother'] },
    {
      'mb-5 not-dark:border-green-500 dark:border-green-900':
        node.attrs['data-action'] === 'add',
    },
    {
      'mt-5 not-dark:border-red-400 dark:border-red-900':
        node.attrs['data-action'] === 'remove',
    }
  )}
  onmouseenter={() => (isHovered = true)}
  onmouseleave={() => (isHovered = false)}
>
  {#if !!node.attrs['data-action'] && isHovered}
    <div
      class={cn(
        'absolute z-10 left-0 flex gap-1 border-b-white/5',
        node.attrs['data-action'] === 'add'
          ? '-bottom-7 border-b-2'
          : '-top-7 border-t-2'
      )}
    >
      <button
        onclick={acceptSuggestion}
        contenteditable="false"
        class="text-suggestion-accept-foreground px-1 cursor-pointer transition hover:bg-white/5"
      >
        Aceitar
      </button>
      <button
        onclick={refuseSuggestion}
        contenteditable="false"
        class="text-suggestion-reject-foreground px-1 cursor-pointer transition hover:bg-white/5"
      >
        Recusar
      </button>
      {#if !node.attrs['data-empty'] && !node.attrs['data-empty-brother']}
        <button
          onclick={keepBothFromSuggestion}
          contenteditable="false"
          class="text-suggestion-both-foreground px-1 cursor-pointer transition hover:bg-white/5"
        >
          Manter ambas
        </button>
      {/if}
    </div>
  {/if}

  <NodeViewContent contenteditable={!node.attrs['data-action']} />
</NodeViewWrapper>

<style>
  :global(*[data-ai-suggestion] :first-child) {
    margin-top: 0;
  }
  :global(*[data-ai-suggestion] :last-child) {
    margin-bottom: 0;
  }

  :global(*[data-ai-suggestion][data-action='add'] *[data-diff]) {
    background: var(--color-diff-accept-background);
  }
  :global(*[data-ai-suggestion][data-action='remove'] *[data-diff]) {
    background: var(--color-diff-reject-background);
  }
</style>

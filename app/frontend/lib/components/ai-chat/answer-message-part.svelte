<script lang="ts">
  /**
   * TODO: Think about a better way of render the diffs because even sanitizing the html, they can contain malicious code and therefore be dangerous
   * For now, we are going to leave it as is, but this is a security risk
   * @since 18/09/2025
   */
  import type { AiSuggestion } from '../turing-sidebar.svelte'
  import type { AnswerPart } from './types'

  type Props = {
    part: AnswerPart
    suggest: (suggestion: AiSuggestion) => void
  }

  let { part, suggest }: Props = $props()
</script>

{#if part.type === 'text'}
  <div class="w-full m-0">
    <!-- eslint-disable-next-line svelte/no-at-html-tags -->
    {@html part.text}
  </div>
{:else if part.type === 'suggestion'}
  <button
    class="w-full m-0 bg-ai-chat-suggestion-background hover:opacity-75 p-1 text-sm border rounded-xs text-left cursor-pointer transition"
    onclick={() => suggest(part.suggestion)}
  >
    <!-- eslint-disable-next-line svelte/no-at-html-tags -->
    {@html part.suggestion.change}
  </button>
{/if}

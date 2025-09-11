<script lang="ts">
  import type { AiSuggestion } from "../turing-sidebar.svelte"
  import type { AnswerPart } from "./types"

  type Props = {
    part: AnswerPart,
    suggest: (suggestion: AiSuggestion) => void,
  }

  let { part, suggest }: Props = $props()
</script>

{#if part.type === 'text'}
  <p class="w-full m-0">{part.text}</p>
{:else if part.type === 'suggestion'}
  <button
    class="w-full m-0 bg-ai-chat-suggestion-background hover:opacity-75 p-1 text-sm border rounded-xs text-left cursor-pointer transition"
    onclick={() => suggest(part.suggestion)}
  >
    <!-- svelte-ignore a11y_no_static_element_interactions -->
    {@html part.suggestion.change}
  </button>
{/if}
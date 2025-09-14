<script lang="ts">
  import { id } from 'date-fns/locale'
  import type { AiSuggestion } from '../turing-sidebar.svelte'
  import AnswerMessagePart from './answer-message-part.svelte'
  import type { Answer } from './types'

  type Props = {
    answer: Answer
    suggest: (suggestion: AiSuggestion) => void
  }

  let { answer, suggest }: Props = $props()
</script>

<div class="mr-4">
  <span class="block opacity-50 text-xs">Turing</span>
  {#if answer === 'error'}
    <p class="w-full m-0 text-red-400 text-sm">
      Desculpe. Não estou funcionando corretamente agora. Tente de novo mais
      tarde.
    </p>
  {:else}
    {#each answer as part, index (index)}
      <AnswerMessagePart {part} {suggest} />
    {/each}
  {/if}
</div>

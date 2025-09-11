<script lang="ts">
  import AiQuestionMessage from './question-message.svelte'
  import AiAnswerMessage from './answer-message.svelte'
  import type { AiSuggestion } from '../turing-sidebar.svelte'
  import type { ConversationPart } from './types'

  type Props = {
    statement: ConversationPart,
    suggest: (suggestion: AiSuggestion) => void,
  }

  let { statement, suggest }: Props = $props()
</script>

{#if statement.type === 'question'}
    <AiQuestionMessage question={statement.question} />
{:else}
  <AiAnswerMessage answer={statement.answer} {suggest} />
{/if}
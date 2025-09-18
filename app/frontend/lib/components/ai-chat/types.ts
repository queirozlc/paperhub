import { AiSuggestion } from '$lib/components/turing-sidebar.svelte'

export type AnswerPart =
  | {
      type: 'text'
      text: string
    }
  | {
      type: 'suggestion'
      suggestion: AiSuggestion
    }

export type Answer = AnswerPart[] | 'error'

export type ConversationPart =
  | {
      type: 'question'
      question: string
    }
  | {
      type: 'answer'
      answer: Answer
    }

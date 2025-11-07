<script lang="ts">
  import * as Sidebar from '$lib/components/ui/sidebar'
  import {
    Edit03,
    Image01,
    InfoCircle,
    MessageQuestionCircle,
    Plus,
    Send01,
    Translate01,
    Loading02 as Loading,
  } from '@voolt_technologies/untitledui-svelte'
  import Button from './ui/button/button.svelte'
  import Textarea from './ui/textarea/textarea.svelte'
  import Icon from './ui/icon/Icon.svelte'
  import turingSvg from '$assets/turing.svg'
  import { aiApiService } from '$lib/services/ai-api-service'
  import {
    extractNodeHtmlContent,
    setIdsToNewAiSuggestions,
    diffHtml,
  } from '$lib/utils'
  import AiChatMessage from './ai-chat/chat-message.svelte'
  import type { Editor } from '@tiptap/core'
  import type { Node as NodeType } from '@tiptap/pm/model'
  import type { AnswerPart, ConversationPart } from './ai-chat/types'

  export type AiSuggestion = {
    id?: number
    change: string
    explanation: string
  }

  type TuringResponse = {
    answer: string
    modifiedDocument: string | null
    suggestions: AiSuggestion[]
  }

  type Props = {
    editor: Editor
  }

  let { editor }: Props = $props()

  let question = $state('')
  let loading = $state(false)
  let conversation = $state<ConversationPart[]>([])
  let nextSuggestionIndex = $state(0)
  let suggestions = $state<AiSuggestion[]>([])

  let chatRef: HTMLDivElement = $state(null)
  let textareaRef: HTMLTextAreaElement = $state(null)

  function resize(
    event: Event & {
      currentTarget: EventTarget & HTMLTextAreaElement
    }
  ) {
    if (textareaRef) {
      const target = event.target as HTMLTextAreaElement
      textareaRef.style.height = 'auto'
      textareaRef.style.height = `${target.scrollHeight - 0}px`
    }
  }

  function startNewChat() {
    conversation = []
  }

  function scrollChatDown() {
    if (chatRef) {
      chatRef.scrollTop = chatRef.scrollHeight
    }
  }

  $effect(() => {
    if (loading) {
      scrollChatDown()
    }
  })

  async function submitQuestion(e?: Event) {
    e?.preventDefault()

    question = question.trim()
    if (question === '') {
      return
    }

    loading = true
    appendQuestionToConversation(question)

    const body = {
      document: editor.getHTML(),
      question,
    }

    question = ''

    try {
      const res = await aiApiService.post('/ask', body)
      const data = res.data as TuringResponse

      processAiResponse(data)
    } catch (e) {
      console.error('Error:', e)
      appendErrorToConversation()
    } finally {
      loading = false
    }
  }

  function processAiResponse(data: TuringResponse) {
    appendAnswerToConversation(data)
    updateEditorWithConversation(data)
    recordSuggestions(data)
  }

  function appendQuestionToConversation(question: string) {
    conversation.push({
      type: 'question',
      question,
    })
  }

  function appendAnswerToConversation(data: TuringResponse) {
    const answerParts: AnswerPart[] = splitAnswer(data.answer, data.suggestions)
    conversation.push({
      type: 'answer',
      answer: answerParts,
    })
  }

  function appendErrorToConversation() {
    conversation.push({
      type: 'answer',
      answer: 'error',
    })
  }

  function updateEditorWithConversation(data: TuringResponse) {
    if (data.modifiedDocument) {
      const newDocumentContent = setIdsToNewAiSuggestions(
        data.modifiedDocument,
        nextSuggestionIndex
      )
      replaceEditorContent(newDocumentContent)
    }
  }

  function recordSuggestions(data: TuringResponse) {
    data.suggestions.forEach((s, i) => {
      s.id = i + nextSuggestionIndex
    })
    suggestions = data.suggestions
    nextSuggestionIndex += suggestions.length
  }

  /**
   *
   * @param answer
   * @param suggestions
   */
  function splitAnswer(
    answer: string,
    suggestions: AiSuggestion[]
  ): AnswerPart[] {
    const parts: AnswerPart[] = []
    const regex = /\{\{(\d+)\}\}/g

    let lastIndex = 0
    let match: RegExpExecArray

    while ((match = regex.exec(answer)) !== null) {
      if (match.index > lastIndex) {
        parts.push({
          type: 'text',
          text: answer.slice(lastIndex, match.index),
        })
      }

      const suggestionIdx = match[1]

      parts.push({
        type: 'suggestion',
        suggestion: suggestions[suggestionIdx],
      })

      lastIndex = regex.lastIndex
    }

    if (lastIndex < answer.length) {
      parts.push({
        type: 'text',
        text: answer.slice(lastIndex),
      })
    }

    return parts
  }

  function replaceEditorContent(modifiedDocument: string) {
    editor.chain().focus().clearContent().setContent(modifiedDocument).run()
  }

  function suggest(suggestion: AiSuggestion) {
    let node: NodeType
    let diff: { original: string; suggestion: string } = null

    editor
      .chain()
      .focus()
      .selectAiSuggestion({ 'data-id': suggestion.id, 'data-action': null })
      .command(({ editor, tr }) => {
        const { selection } = tr

        if (selection.empty) {
          throw 'Sugestão não pode ser exibida pois já está sendo exibida ou já foi aprovada'
        }

        const pos = selection.from
        node = tr.doc.nodeAt(pos)

        const htmlContent = extractNodeHtmlContent(editor, node)
        const [originalDiff, suggestionDiff] = diffHtml(
          htmlContent,
          suggestion.change
        )
        diff = {
          original: originalDiff,
          suggestion: suggestionDiff,
        }

        return true
      })
      .updateAiSuggestion(
        {
          ...node.attrs,
          'data-action': 'remove',
          'data-empty': diff.original.length === 0,
          'data-empty-brother': diff.suggestion.length === 0,
        },
        diff.original
      )
      .addAiSuggestionBellow(
        {
          ...node.attrs,
          'data-action': 'add',
          'data-empty': diff.suggestion.length === 0,
          'data-empty-brother': diff.original.length === 0,
        },
        diff.suggestion
      )
      .run()
  }

  function handleTextareaKeyDown(e: KeyboardEvent) {
    // if not shift + enter, submit the form
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault()

      submitQuestion(e)
    }
  }
</script>

<Sidebar.Root side="right" transparent>
  <Sidebar.Header class="border-sidebar-border h-14 border-b"></Sidebar.Header>
  <Sidebar.Content class="px-2">
    <Sidebar.Group class="border-b border-sidebar-border">
      <div class="flex items-center justify-between">
        <span class="text-muted-foreground text-sm font-semibold font-brand"
          >Turing AI</span
        >
        <Button
          size="icon"
          variant="ghost"
          class="hover:text-accent-foreground text-muted-foreground"
        >
          <InfoCircle class="size-4" />
        </Button>
      </div>
    </Sidebar.Group>

    <Sidebar.Group
      bind:ref={chatRef}
      class="block items-center h-full justify-center gap-5 overflow-y-auto"
    >
      {#if conversation.length !== 0}
        <div class="flex flex-col gap-4 w-full">
          {#each conversation as statement, index (index)}
            <AiChatMessage {statement} {suggest} />
          {/each}

          {#if loading}
            <div class="mr-4">
              <span class="block opacity-50 text-xs">Turing</span>
              <Loading class="animate-spin duration-2000 mt-1" size={15} />
            </div>
          {/if}
        </div>
      {:else}
        <div class="flex flex-col items-center justify-center gap-4">
          <div
            class="shadow-md rounded-md bg-popover p-2 w-fit flex items-center justify-center"
          >
            <img src={turingSvg} alt="Turing AI icon" />
          </div>
          <h3 class="font-brand font-semibold text-sm text-accent-foreground">
            Como posso ajudar ?
          </h3>
        </div>

        <ul class="flex flex-col items-center justify-center gap-4">
          <li
            class="text-muted-foreground cursor-pointer flex items-center hover:underline gap-2"
          >
            <Translate01 class="size-4" />
            <span class="font-medium font-brand text-xs text-center"
              >Leia artigos em qualquer idioma</span
            >
          </li>

          <li
            class="text-muted-foreground cursor-pointer group flex hover:underline items-center gap-2"
          >
            <Edit03 class="size-4" />
            <span class="font-medium font-brand text-xs text-left"
              >Escreva com a ajuda do Turing AI</span
            >
          </li>

          <li
            class="text-muted-foreground cursor-pointer flex hover:underline items-center gap-2"
          >
            <MessageQuestionCircle class="size-4" />
            <span class="font-medium font-brand text-xs text-left"
              >Tire alguma dúvida sobre o tema</span
            >
          </li>
        </ul>
      {/if}
    </Sidebar.Group>
  </Sidebar.Content>

  <Sidebar.Footer class="px-2">
    <div class="flex flex-col justify-center gap-4">
      <form
        class="relative"
        onsubmit={submitQuestion}
        id="turing-sidebar-form"
        name="turing-sidebar-form"
      >
        <Textarea
          form="turing-sidebar-form"
          bind:ref={textareaRef}
          placeholder="Do que você está precisando ?"
          class="resize-none pb-10 no-scrollbar"
          bind:value={question}
          oninput={resize}
          onkeydown={handleTextareaKeyDown}
        />

        <div class="absolute gap-2 bottom-2 left-2 flex items-center">
          <Button
            size="icon"
            variant="outline"
            class="size-6 text-muted-foreground hover:text-accent-foreground"
            title="Novo chat"
            onclick={startNewChat}
          >
            <Plus />
          </Button>

          <Button
            title="Limpar tudo"
            variant="ghost"
            size="icon"
            class="size-6 text-muted-foreground hover:text-accent-foreground"
            onclick={() => (question = '')}
          >
            <Icon name="broom" />
          </Button>
        </div>

        <div class="absolute gap-2 bottom-2 right-2 flex items-center">
          <Button
            title="Anexar arquivo"
            variant="ghost"
            size="icon"
            class="size-6 text-muted-foreground hover:text-accent-foreground"
          >
            <Image01 />
          </Button>

          <Button
            title="Enviar"
            type="submit"
            variant="outline"
            size="icon"
            class="size-6 text-muted-foreground hover:text-accent-foreground"
          >
            <Send01 />
          </Button>
        </div>
      </form>

      <div class="flex items-center text-muted-foreground gap-2">
        <InfoCircle class="size-6" />
        <span class="text-xs font-medium">
          Lembre-se sempre de checar se a resposta está correta.
        </span>
      </div>
    </div>
  </Sidebar.Footer>
</Sidebar.Root>

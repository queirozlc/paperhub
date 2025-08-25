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
  import turingSvg from '@/assets/turing.svg'
  import { aiApiService } from '@/services/ai-api-service'
  import {
    extractNodeHtmlContent,
    highlightHtmlDifferences,
    setIdsToNewSuggestions,
  } from '../suggestion-utils'
  import type { Editor } from '@tiptap/core'
  import type { Node as NodeType } from '@tiptap/pm/model'

  export type Suggestion = {
    id?: number
    change: string
    explanation: string
  }

  type TuringResponse = {
    answer: string
    modifiedDocument: string | null
    suggestions: Suggestion[]
  }

  type ConversationPart =
    | {
        type: 'question'
        question: string
      }
    | {
        type: 'answer'
        answer: AnswerPart[] | 'error'
      }

  type AnswerPart =
    | {
        type: 'text'
        text: string
      }
    | {
        type: 'suggestion'
        suggestion: Suggestion
      }

  type Props = {
    editor: Editor
  }

  let { editor }: Props = $props()

  let question = $state('')
  let loading = $state(false)
  let conversation = $state<ConversationPart[]>([])
  let nextSuggestionIndex = $state(0)
  let suggestions = $state<Suggestion[]>([])

  let chatRef: HTMLDivElement = $state(null)
  let textareaRef: HTMLTextAreaElement = $state(null)

  function resize(
    event: Event & {
      currentTarget: EventTarget & HTMLTextAreaElement
    }
  ) {
    if (textareaRef) {
      const target = event.target as HTMLInputElement
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

  async function submitQuestion() {
    question = question.trim()
    if (question === '') {
      return
    }

    loading = true
    conversation.push({
      type: 'question',
      question,
    })

    const body = {
      document: editor.getHTML(),
      question,
    }

    question = ''

    try {
      const res = await aiApiService.post('/ask', body)
      const data = res.data as TuringResponse

      const answerParts: AnswerPart[] = splitResponse(
        data.answer,
        data.suggestions
      )

      conversation.push({
        type: 'answer',
        answer: answerParts,
      })

      if (data.modifiedDocument) {
        const newDocumentContent = setIdsToNewSuggestions(
          data.modifiedDocument,
          nextSuggestionIndex
        )
        replaceEditorContent(newDocumentContent)
      }

      data.suggestions.forEach((s, i) => {
        s.id = i + nextSuggestionIndex
      })
      suggestions = data.suggestions
      nextSuggestionIndex += suggestions.length
    } catch (e) {
      console.error('Error:', e)
      conversation.push({
        type: 'answer',
        answer: 'error',
      })
    } finally {
      loading = false
    }
  }

  function splitResponse(response: string, suggestions: Suggestion[]) {
    const parts: AnswerPart[] = []
    const regex = /\{\{(\d+)\}\}/g

    let lastIndex = 0
    let match: RegExpExecArray

    while ((match = regex.exec(response)) !== null) {
      // Adiciona o texto antes do padrão {{n}}
      if (match.index > lastIndex) {
        parts.push({
          type: 'text',
          text: response.slice(lastIndex, match.index),
        })
      }

      const suggestionIdx = match[1]

      // Adiciona o padrão {{n}} como um objeto span
      parts.push({
        type: 'suggestion',
        suggestion: suggestions[suggestionIdx],
      })

      lastIndex = regex.lastIndex
    }

    // Adiciona o texto restante após o último padrão
    if (lastIndex < response.length) {
      parts.push({
        type: 'text',
        text: response.slice(lastIndex),
      })
    }

    return parts
  }

  function replaceEditorContent(modifiedDocument: string) {
    editor.chain().focus().clearContent().setContent(modifiedDocument).run()
  }

  function suggest(suggestion: Suggestion) {
    let node: NodeType
    let diff: { original: string; suggestion: string } = null

    editor
      .chain()
      .focus()
      .selectSuggestion({ 'data-id': suggestion.id, 'data-action': null })
      .command(({ tr }) => {
        const { selection } = tr

        if (selection.empty) {
          throw 'Sugestão não pode ser exibida pois já está sendo exibida ou já foi aprovada'
        }

        const pos = selection.from
        node = tr.doc.nodeAt(pos)

        const htmlContent = extractNodeHtmlContent(node)
        const [originalDiff, suggestionDiff] = highlightHtmlDifferences(
          htmlContent,
          suggestion.change
        )
        diff = {
          original: originalDiff,
          suggestion: suggestionDiff,
        }

        return true
      })
      .updateSuggestion(
        {
          ...node.attrs,
          'data-action': 'remove',
          'data-empty': diff.original.length === 0,
          'data-empty-brother': diff.suggestion.length === 0,
        },
        diff.original
      )
      .addSuggestionBellow(
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
</script>

<Sidebar.Root side="right" transparent>
  <Sidebar.Header class="border-sidebar-border h-14 border-b"></Sidebar.Header>
  <Sidebar.Content class="px-2">
    <Sidebar.Group class="border-b border-white/4">
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
          {#each conversation as statement}
            {#if statement.type === 'question'}
              <div class="ml-4 self-end">
                <span class="block opacity-50 text-xs text-right">você</span>
                {statement.question}
              </div>
            {:else}
              <div class="mr-4">
                <span class="block opacity-50 text-xs">Turing</span>
                {#if statement.answer === 'error'}
                  <p class="w-full m-0 text-red-400 text-sm">
                    Desculpe. Não estou funcionando corretamente agora. Tente de
                    novo mais tarde.
                  </p>
                {:else}
                  {#each statement.answer as part}
                    {#if part.type === 'text'}
                      <p class="w-full m-0">{part.text}</p>
                    {:else if part.type === 'suggestion'}
                      <button
                        class="w-full m-0 bg-white/4 hover:bg-white/8 p-1 text-sm border rounded-xs text-left cursor-pointer transition"
                        onclick={() => suggest(part.suggestion)}
                      >
                        <!-- svelte-ignore a11y_no_static_element_interactions -->
                        {@html part.suggestion.change}
                      </button>
                    {/if}
                  {/each}
                {/if}
              </div>
            {/if}
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
            <img src={turingSvg} alt="Turing AI image" />
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
      <div class="relative">
        <Textarea
          bind:ref={textareaRef}
          placeholder="Do que você está precisando ?"
          class="resize-none pb-10 no-scrollbar"
          bind:value={question}
          oninput={resize}
          onkeydown={(e) => {
            if (e.ctrlKey && e.key === 'Enter') {
              e.preventDefault()
              submitQuestion()
            }
          }}
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
            variant="outline"
            size="icon"
            class="size-6 text-muted-foreground hover:text-accent-foreground"
            onclick={submitQuestion}
          >
            <Send01 />
          </Button>
        </div>
      </div>

      <div class="flex items-center text-muted-foreground gap-2">
        <InfoCircle class="size-6" />
        <span class="text-xs font-medium">
          Lembre-se sempre de checar se a resposta está correta.
        </span>
      </div>
    </div>
  </Sidebar.Footer>
</Sidebar.Root>

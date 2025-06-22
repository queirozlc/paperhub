<script lang="ts">
  import * as Sidebar from '@/lib/components/ui/sidebar'
  import {
    Edit03,
    Image01,
    InfoCircle,
    MessageQuestionCircle,
    Plus,
    Send01,
    Translate01,
  } from '@voolt_technologies/untitledui-svelte'
  import Button from './ui/button/button.svelte'
  import Textarea from './ui/textarea/textarea.svelte'
  import Icon from './ui/icon/Icon.svelte'
  import turingSvg from '@/assets/turing.svg'
  import { aiApiService } from '@/services/ai-api-service'

  export type Suggestion = {
    id?: number,
    text: string,
    action: 'add' | 'replace' | 'delete',
    explanation: string,
  }

  type TuringResponse = {
    response: string,
    modifiedDocument: string | null,
    suggestions: Suggestion[],
  }

  type Props = {
    getContent: () => string,
    updateEditorWithSuggestions: (modifiedDocument: string, nextSuggestionIndex: number) => void
    suggest: (suggestion: Suggestion) => void
  }

  let { getContent, updateEditorWithSuggestions, suggest }: Props = $props()

  let question = $state('')
  let response = $state('')
  let nextSuggestionIndex = $state(0)
  let suggestions = $state<Suggestion[]>([])

  let ref: HTMLTextAreaElement = $state(null)

  function resize(
    event: Event & {
      currentTarget: EventTarget & HTMLTextAreaElement
    }
  ) {
    if (ref) {
      const target = event.target as HTMLInputElement
      ref.style.height = 'auto'
      ref.style.height = `${target.scrollHeight - 0}px`
    }
  }

  async function submitQuestion() {
    if (question.trim() === '') {
      return
    }

    const body = {
      document: getContent(),
      question: question.trim(),
    }

    question = ''

    try {
      const res = await aiApiService.post('/ask', body)
      const data = res.data as TuringResponse

      console.log('Response:', data)

      response = data.response

      if (data.modifiedDocument) {
        updateEditorWithSuggestions(data.modifiedDocument, nextSuggestionIndex)
      }

      data.suggestions.forEach((s, i) => {
        s.id = i + nextSuggestionIndex++
      })
      suggestions = data.suggestions
      
    } catch (e) {
      console.error('Error:', e)
    }
  }
</script>

<Sidebar.Root side="right" transparent>
  <Sidebar.Header class="border-sidebar-border h-14 border-b"></Sidebar.Header>
  <Sidebar.Content class="px-2">
    <Sidebar.Group>
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

    {#if response}
      <Sidebar.Group class="items-center h-full justify-center gap-5">
        { response }
      </Sidebar.Group>
    {:else}
      <Sidebar.Group class="items-center h-full justify-center gap-5">
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
      </Sidebar.Group>
    {/if}
  </Sidebar.Content>

  <Sidebar.Footer class="px-2">
    <div class="flex flex-col justify-center gap-4">
      <div class="flex gap-1">
        <Button size="icon" variant="outline" class="size-6">
          <Plus />
        </Button>
        <Button size="icon" variant="outline" class="size-6" onclick={() => suggest(suggestions[0])}>
          T
        </Button>
      </div>

      <div class="relative">
        <Textarea
          bind:ref
          placeholder="Do que você está precisando ?"
          class="resize-none pb-10 no-scrollbar"
          bind:value={question}
          oninput={resize}
        />
        <Button
          title="Limpar tudo"
          variant="ghost"
          size="icon"
          class="size-6 absolute bottom-2 left-2 text-muted-foreground hover:text-accent-foreground"
        >
          <Icon name="broom" />
        </Button>

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

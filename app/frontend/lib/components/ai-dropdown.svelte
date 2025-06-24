<script lang="ts" module>
</script>

<script lang="ts">
  import Button from '$lib/components/ui/button/button.svelte'
  import * as DropdownMenu from '$lib/components/ui/dropdown-menu'
  import {
    CircleSlash,
    Eraser,
    FileText,
    Icon,
    Languages,
    PencilLine,
    SparklesIcon,
  } from '@lucide/svelte'
  import { ChevronDown } from '@voolt_technologies/untitledui-svelte'

  import type { Editor } from 'svelte-tiptap'

  type Props = {
    editor: Editor
  }

  type Item = {
    slug: string
    icon?: typeof Icon
    label: string
    onClick: () => void
    subContent?: Item[]
  }

  let aiToolsDropdownContent = $state<HTMLDivElement>(null)

  let { editor }: Props = $props()

  const items: Item[] = [
    {
      slug: 'simplify',
      icon: CircleSlash,
      label: 'Simplificar',
      onClick: () => {
        console.log('Simplificar')
      },
    },
    {
      slug: 'spell-check',
      icon: Eraser,
      label: 'Correção ortográfica',
      onClick: () => {
        console.log('Correção ortográfica')
      },
    },
    {
      slug: 'summarize',
      icon: FileText,
      label: 'Resumir',
      onClick: () => {
        console.log('Resumir')
      },
    },
    {
      slug: 'translate',
      icon: Languages,
      label: 'Traduzir',
      onClick: () => {
        console.log('Traduzir')
      },
      subContent: [
        {
          slug: 'translate-to-english',
          label: 'Inglês',
          onClick: () => {
            console.log('Para inglês')
          },
        },
      ],
    },
    {
      slug: 'complete-sentence',
      icon: PencilLine,
      label: 'Completar frase',
      onClick: () => {
        console.log('Completar frase')
      },
    },
  ]
</script>

<DropdownMenu.Root
  onOpenChange={(open) => {
    if (open && aiToolsDropdownContent) {
      aiToolsDropdownContent.focus()
    }
  }}
>
  <DropdownMenu.Trigger>
    <Button
      size="sm"
      variant="ghost"
      class="gap-2 items-center hover:text-primary text-primary font-semibold"
    >
      <SparklesIcon class="size-4" />
      <div class="flex items-center gap-1">
        <span class="text-sm font-brand">Turing IA</span>
        <ChevronDown class="size-3" />
      </div>
    </Button>
  </DropdownMenu.Trigger>
  <DropdownMenu.Content
    onOpenAutoFocus={(e) => e.preventDefault()}
    bind:ref={aiToolsDropdownContent}
    sideOffset={4}
  >
    <DropdownMenu.Group class="text-muted-foreground">
      {#each items as item (item.slug)}
        {#if item.subContent}
          <DropdownMenu.Sub>
            <DropdownMenu.SubTrigger class="cursor-pointer">
              <item.icon class="size-4" />
              <span class="text-sm font-medium font-brand">{item.label}</span>
            </DropdownMenu.SubTrigger>
            <DropdownMenu.SubContent sideOffset={8}>
              {#each item.subContent as subItem (subItem.slug)}
                <DropdownMenu.Item onclick={subItem.onClick}>
                  <subItem.icon class="size-4" />
                  <span class="text-sm font-medium font-brand"
                    >{subItem.label}</span
                  >
                </DropdownMenu.Item>
              {/each}
            </DropdownMenu.SubContent>
          </DropdownMenu.Sub>
        {:else}
          <DropdownMenu.Item onclick={item.onClick}>
            <item.icon class="size-4" />
            <span class="text-sm font-medium font-brand">{item.label}</span>
          </DropdownMenu.Item>
        {/if}
      {/each}
    </DropdownMenu.Group>
  </DropdownMenu.Content>
</DropdownMenu.Root>

<script lang="ts">
  import type { Editor } from 'svelte-tiptap'
  import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuTrigger,
  } from '../ui/dropdown-menu'
  import { Button } from '../ui/button'
  import { ChevronDown } from '@voolt_technologies/untitledui-svelte'
  import {
    AlignLeft,
    AlignCenter,
    AlignRight,
    AlignJustify,
  } from '@lucide/svelte'
  import {
    Tooltip,
    TooltipProvider,
    TooltipTrigger,
    TooltipContent,
  } from '../ui/tooltip'

  type Props = {
    editor: Editor
  }

  let { editor }: Props = $props()

  const ALIGNMENTS = ['left', 'center', 'right', 'justify']

  let currentAlignment = $derived(
    ALIGNMENTS.find((alignment) =>
      editor.isActive({ textAlign: alignment })
    ) as 'left' | 'center' | 'right' | 'justify' | null
  )
</script>

{#snippet icon(alignment: 'left' | 'center' | 'right' | 'justify')}
  {#if !alignment || alignment === 'left'}
    <AlignLeft class="size-4" />
  {:else if alignment === 'center'}
    <AlignCenter class="size-4" />
  {:else if alignment === 'right'}
    <AlignRight class="size-4" />
  {:else if alignment === 'justify'}
    <AlignJustify class="size-4" />
  {/if}
{/snippet}

<DropdownMenu>
  <TooltipProvider>
    <Tooltip disableHoverableContent delayDuration={0}>
      <TooltipTrigger>
        <DropdownMenuTrigger>
          <Button variant="ghost" size="sm" class="px-1">
            <div class="flex items-center gap-1">
              {@render icon(currentAlignment)}
              <ChevronDown class="size-3" />
            </div>
          </Button>
        </DropdownMenuTrigger>
      </TooltipTrigger>

      <TooltipContent>Alinhar texto</TooltipContent>
    </Tooltip>
  </TooltipProvider>

  <DropdownMenuContent>
    <DropdownMenuItem
      onclick={() => editor.chain().focus().setTextAlign('left').run()}
    >
      <AlignLeft class="size-4" />
      <span class="text-sm font-medium font-brand">Esquerda</span>
    </DropdownMenuItem>
    <DropdownMenuItem
      onclick={() => editor.chain().focus().setTextAlign('center').run()}
    >
      <AlignCenter class="size-4" />
      <span class="text-sm font-medium font-brand">Centro</span>
    </DropdownMenuItem>
    <DropdownMenuItem
      onclick={() => editor.chain().focus().setTextAlign('right').run()}
    >
      <AlignRight class="size-4" />
      <span class="text-sm font-medium font-brand">Direita</span>
    </DropdownMenuItem>
    <DropdownMenuItem
      onclick={() => editor.chain().focus().setTextAlign('justify').run()}
    >
      <AlignJustify class="size-4" />
      <span class="text-sm font-medium font-brand">Justificar</span>
    </DropdownMenuItem>
  </DropdownMenuContent>
</DropdownMenu>

<script lang="ts">
  import * as DropdownMenu from '@/lib/components/ui/dropdown-menu'
  import type { MenuListProps } from './types'

  let { command, editor, items }: MenuListProps = $props()
  let customAnchor = $state<HTMLElement>(null!)
  let scrollContainer = $state<HTMLDivElement>(null!)
  let activeItem = $state<HTMLButtonElement>(null!)
  let selectedGroupIndex = $state(0)
  let selectedCommandIndex = $state(0)
</script>

<div bind:this={customAnchor}></div>

<DropdownMenu.Root open>
  <DropdownMenu.Content
    {customAnchor}
    class="rounded-lg bg-background-off"
    align="start"
    side="bottom"
    sideOffset={4}
    onOpenAutoFocus={(e) => e.preventDefault()}
    trapFocus={false}
  >
    <DropdownMenu.Label
      class="text-muted-foreground font-brand pointer-events-none text-xs"
      >AI ✨</DropdownMenu.Label
    >

    <DropdownMenu.Item
      class="truncate leading-none grow font-medium text-sm text-accent-foreground"
      >Corrigir gramática</DropdownMenu.Item
    >

    <DropdownMenu.Separator />

    <DropdownMenu.Label
      class="text-muted-foreground font-brand pointer-events-none text-xs"
    >
      Blocos básicos
    </DropdownMenu.Label>

    {#each items as item, index (index)}
      <DropdownMenu.Item
        onSelect={() => {
          item.command({ editor, range })
        }}
        class="gap-2 p-2"
      >
        <div class="flex items-center gap-2">
          <span class="leading-none font-medium text-sm text-accent-foreground"
            >{item.title}</span
          >
        </div>
      </DropdownMenu.Item>
    {/each}
  </DropdownMenu.Content>
</DropdownMenu.Root>

<script lang="ts">
  import * as DropdownMenu from '$lib/components/ui/dropdown-menu'
  import Button from '$lib/components/ui/button/button.svelte'
  import { ChevronDown } from '@voolt_technologies/untitledui-svelte'
  import type { Editor } from 'svelte-tiptap'

  type Group = {
    slug: string
    label: string
    items: GroupItem[]
  }

  type GroupItem = {
    slug: string
    label: string
    onClick: () => void
  }

  type Props = {
    editor: Editor
  }

  let { editor }: Props = $props()

  let aiToolsDropdownContent = $state<HTMLDivElement>(null)

  const groups: Group[] = [
    {
      slug: 'sans-serif',
      label: 'Sans Serif',
      items: [
        {
          slug: 'arial',
          label: 'Arial',
          onClick: () => editor.chain().focus().setFontFamily('Arial').run(),
        },
        {
          slug: 'helvetica',
          label: 'Helvetica',
          onClick: () =>
            editor.chain().focus().setFontFamily('Helvetica').run(),
        },
        {
          slug: 'inter',
          label: 'Inter',
          onClick: () => editor.chain().focus().setFontFamily('Inter').run(),
        },
      ],
    },
    {
      slug: 'serif',
      label: 'Serif',
      items: [
        {
          slug: 'times-new-roman',
          label: 'Times',
          onClick: () => editor.chain().focus().setFontFamily('Times').run(),
        },
      ],
    },
    {
      slug: 'monospace',
      label: 'Monospace',
      items: [
        {
          slug: 'courier-new',
          label: 'Courier New',
          onClick: () =>
            editor.chain().focus().setFontFamily('Courier New').run(),
        },
        {
          slug: 'monospace',
          label: 'Monospace',
          onClick: () =>
            editor.chain().focus().setFontFamily('monospace').run(),
        },
      ],
    },
  ]

  let currentFont = $derived(
    editor.getAttributes('textStyle')?.fontFamily || 'Inter'
  )
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
      size="default"
      variant="ghost"
      class="gap-2 items-center text-muted-foreground hover:text-foreground"
    >
      <span class="text-sm font-medium font-brand">{currentFont}</span>
      <ChevronDown class="size-3" />
    </Button>
  </DropdownMenu.Trigger>
  <DropdownMenu.Content
    onOpenAutoFocus={(e) => e.preventDefault()}
    bind:ref={aiToolsDropdownContent}
    sideOffset={4}
  >
    {#each groups as group (group.slug)}
      <DropdownMenu.Group class="text-muted-foreground">
        <DropdownMenu.Label
          class="text-[0.625rem] uppercase font-brand text-muted-foreground"
          >{group.label}</DropdownMenu.Label
        >
        {#each group.items as item (item.slug)}
          <DropdownMenu.Item
            onclick={item.onClick}
            data-active={currentFont === item.label}
            class="data-[active=true]:bg-muted data-[active=true]:text-foreground"
          >
            <span class="text-sm font-medium" style="font-family: {item.label}"
              >{item.label}</span
            >
          </DropdownMenu.Item>
        {/each}
      </DropdownMenu.Group>
    {/each}
  </DropdownMenu.Content>
</DropdownMenu.Root>

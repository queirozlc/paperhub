<script lang="ts">
  import * as DropdownMenu from '$lib/components/ui/dropdown-menu'
  import Button from '$lib/components/ui/button/button.svelte'
  import { ChevronDown } from '@voolt_technologies/untitledui-svelte'
  import {
    Heading1,
    Heading2,
    Heading3,
    Icon,
    List,
    ListOrdered,
    Pilcrow,
  } from '@lucide/svelte'
  import type { Editor } from 'svelte-tiptap'

  type Group = {
    slug: string
    label: string
    items: GroupItem[]
  }

  type Props = {
    editor: Editor
  }

  let aiToolsDropdownContent = $state<HTMLDivElement>(null)

  let { editor }: Props = $props()

  type GroupItem = {
    slug: string
    icon: typeof Icon
    label: string
    onClick: () => void
  }

  const groups: Group[] = [
    {
      slug: 'text',
      label: 'Texto',
      items: [
        {
          slug: 'paragraph',
          label: 'Parágrafo',
          icon: Pilcrow,
          onClick: () => {},
        },
        {
          slug: 'heading-1',
          label: 'Título 1',
          icon: Heading1,
          onClick: () =>
            editor.chain().focus().toggleHeading({ level: 1 }).run(),
        },
        {
          slug: 'heading-2',
          label: 'Título 2',
          icon: Heading2,
          onClick: () =>
            editor.chain().focus().toggleHeading({ level: 2 }).run(),
        },
        {
          slug: 'heading-3',
          label: 'Título 3',
          icon: Heading3,
          onClick: () =>
            editor.chain().focus().toggleHeading({ level: 3 }).run(),
        },
      ],
    },
    {
      slug: 'list',
      label: 'Lista',
      items: [
        {
          slug: 'ordered-list',
          label: 'Lista ordenada',
          icon: List,
          onClick: () => editor.chain().focus().toggleBulletList().run(),
        },
        {
          slug: 'numbered-list',
          label: 'Lista numerada',
          icon: ListOrdered,
          onClick: () => editor.chain().focus().toggleOrderedList().run(),
        },
      ],
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
    <Button size="sm" variant="ghost" class="gap-2 items-center px-1">
      <Pilcrow />
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
          <DropdownMenu.Item onclick={item.onClick}>
            <item.icon class="size-4" />
            <span class="text-sm font-medium font-brand">{item.label}</span>
          </DropdownMenu.Item>
        {/each}
      </DropdownMenu.Group>
    {/each}
  </DropdownMenu.Content>
</DropdownMenu.Root>

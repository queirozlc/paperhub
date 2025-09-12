<script lang="ts">
  import type { Editor } from 'svelte-tiptap'
  import { Toggle } from '$lib/components/ui/toggle'
  import {
    Tooltip,
    TooltipContent,
    TooltipProvider,
    TooltipTrigger,
  } from '$lib/components/ui/tooltip'
  import {
    Popover,
    PopoverContent,
    PopoverTrigger,
  } from '$lib/components/ui/popover'
  import {
    AlignLeft,
    AlignCenter,
    Bold,
    AlignRight,
    AlignJustify,
    Icon,
    Italic,
    Link,
    Strikethrough,
    Underline,
  } from '@lucide/svelte'
  import Button from './ui/button/button.svelte'
  import LinkEditorPanel from './link-editor-panel.svelte'
  import { DEFAULT_PROTOCOL } from '$lib/constants'

  type Props = {
    editor: Editor
  }

  type ToggleItem = {
    slug: string
    icon: typeof Icon
    onClick: () => void
    shortcut: string | string[]
    tooltip: string
    kind: 'node' | 'mark'
  }

  let { editor }: Props = $props()

  let url = $state('')
  let protocol = $state(DEFAULT_PROTOCOL)
  let openInNewTab = $state(false)
  let open = $state(false)

  const items: ToggleItem[] = [
    {
      slug: 'left',
      icon: AlignLeft,
      shortcut: ['Mod', 'L'],
      tooltip: 'Alinhar à esquerda',
      onClick: () => editor.chain().focus().setTextAlign('left').run(),
      kind: 'node',
    },
    {
      slug: 'center',
      icon: AlignCenter,
      shortcut: ['Mod', 'C'],
      tooltip: 'Alinhar ao centro',
      onClick: () => editor.chain().focus().setTextAlign('center').run(),
      kind: 'node',
    },
    {
      slug: 'right',
      icon: AlignRight,
      shortcut: ['Mod', 'R'],
      tooltip: 'Alinhar à direita',
      onClick: () => editor.chain().focus().setTextAlign('right').run(),
      kind: 'node',
    },
    {
      slug: 'justify',
      icon: AlignJustify,
      shortcut: ['Mod', 'J'],
      tooltip: 'Justificar',
      onClick: () => editor.chain().focus().setTextAlign('justify').run(),
      kind: 'node',
    },
    {
      slug: 'bold',
      icon: Bold,
      shortcut: ['Mod', 'B'],
      onClick: () => editor.chain().toggleBold().run(),
      tooltip: 'Negrito',
      kind: 'mark',
    },
    {
      slug: 'italic',
      icon: Italic,
      shortcut: ['Mod', 'I'],
      onClick: () => editor.chain().toggleItalic().run(),
      tooltip: 'Itálico',
      kind: 'mark',
    },
    {
      slug: 'underline',
      icon: Underline,
      shortcut: ['Mod', 'U'],
      onClick: () => editor.chain().toggleUnderline().run(),
      tooltip: 'Sublinhado',
      kind: 'mark',
    },
    {
      slug: 'strike',
      icon: Strikethrough,
      shortcut: ['Mod', 'Shift', 'S'],
      onClick: () => editor.chain().toggleStrike().run(),
      tooltip: 'Tachado',
      kind: 'mark',
    },
    {
      slug: 'link',
      icon: Link,
      onClick: () => {
        if (url) {
          editor
            .chain()
            .focus()
            .setLink({
              href: `${protocol}${url}`,
              target: openInNewTab ? '_blank' : '_self',
            })
            .run()
        } else {
          editor.chain().focus().unsetLink().run()
        }

        open = false
      },
      shortcut: ['Mod', 'Shift', 'K'],
      tooltip: 'Inserir link',
      kind: 'mark',
    },
  ]

  $inspect(editor)

  let pressedStates = $derived(
    items.map(({ slug, kind }) =>
      kind === 'mark'
        ? editor.isActive(slug)
        : editor.isActive({ textAlign: slug })
    )
  )
</script>

<div>
  {#each items as item, index (item.slug)}
    <TooltipProvider delayDuration={0} disableHoverableContent>
      <Tooltip>
        {#if item.slug === 'link'}
          <TooltipTrigger>
            <Popover bind:open>
              <PopoverTrigger>
                <Button size="sm" variant="ghost" class="px-2">
                  <item.icon class="size-4" />
                </Button>
              </PopoverTrigger>

              <PopoverContent sideOffset={10} class="p-0 w-full">
                <LinkEditorPanel
                  bind:protocol
                  bind:url
                  bind:openInNewTab
                  onSubmit={item.onClick}
                />
              </PopoverContent>
            </Popover>
          </TooltipTrigger>
        {:else}
          <TooltipTrigger>
            <Toggle
              size="sm"
              class="cursor-pointer"
              onclick={item.onClick}
              bind:pressed={
                () => pressedStates[index],
                (updatedValue) => {
                  pressedStates[index] = updatedValue
                }
              }
            >
              <item.icon class="size-4" />
            </Toggle>
          </TooltipTrigger>
        {/if}
        <TooltipContent shortcutKey={item.shortcut} class="font-medium">
          {item.tooltip}
        </TooltipContent>
      </Tooltip>
    </TooltipProvider>
  {/each}
</div>

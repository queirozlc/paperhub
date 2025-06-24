<script lang="ts">
  import type { Editor } from 'svelte-tiptap'
  import { Toggle } from '$lib/components/ui/toggle'
  import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '$lib/components/ui/tooltip'
  import { Popover, PopoverContent, PopoverTrigger } from '$lib/components/ui/popover'
  import { Bold, Icon, Italic, Link, Strikethrough, Underline } from '@lucide/svelte'
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
  }

  let { editor }: Props = $props()

  let url = $state('')
  let protocol = $state(DEFAULT_PROTOCOL)
  let openInNewTab = $state(false)
  let open = $state(false)

  const items: ToggleItem[] = [
    {
      slug: 'bold',
      icon: Bold,
      shortcut: ['Mod', 'B'],
      onClick: () => editor.chain().toggleBold().run(),
      tooltip: 'Bold',
    },
    {
      slug: 'italic',
      icon: Italic,
      shortcut: ['Mod', 'I'],
      onClick: () => editor.chain().toggleItalic().run(),
      tooltip: 'Italic',
    },
    {
      slug: 'underline',
      icon: Underline,
      shortcut: ['Mod', 'U'],
      onClick: () => editor.chain().toggleUnderline().run(),
      tooltip: 'Underline',
    },
    {
      slug: 'strike',
      icon: Strikethrough,
      shortcut: ['Mod', 'Shift', 'S'],
      onClick: () => editor.chain().toggleStrike().run(),
      tooltip: 'Strikethrough',
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
      tooltip: 'Link',
    },
  ]
</script>

<div>
  {#each items as item (item.slug)}
    <TooltipProvider delayDuration={0} disableHoverableContent>
      <Tooltip>
        {#if item.slug === 'link'}
          <TooltipTrigger>
            <Popover bind:open>
              <PopoverTrigger>
                <Button size="sm" variant="ghost">
                  <item.icon class="size-4" />
                </Button>
              </PopoverTrigger>

              <PopoverContent sideOffset={10} trapFocus={false} class="p-0">
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
          <Tooltip>
            <Toggle size="sm" class="cursor-pointer" onclick={item.onClick}>
              <item.icon class="size-4" />
            </Toggle>
          </Tooltip>
        {/if}
        <TooltipContent shortcutKey={item.shortcut} class="font-medium">
          {item.tooltip}
        </TooltipContent>
      </Tooltip>
    </TooltipProvider>
  {/each}
</div>

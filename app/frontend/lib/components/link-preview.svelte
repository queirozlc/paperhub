<script lang="ts">
  import { Icon, Link, Pen, Unlink } from '@lucide/svelte'
  import { CopyButton } from './ui/copy-button'
  import { Button } from './ui/button'
  import { Editor } from 'svelte-tiptap'
  import SimpleTooltip from './simple-tooltip.svelte'
  type Props = {
    url: string
    editor: Editor
    editMode: boolean
  }

  let { url, editor, editMode = $bindable(false) }: Props = $props()

  let copied = $state(false)

  type ActionButton = {
    name: string
    icon: typeof Icon
    info: string
    onClick: () => void
  }

  const actionButtons: ActionButton[] = [
    {
      name: 'edit',
      info: 'Editar endereço',
      icon: Pen,
      onClick: () => {
        editMode = true
      },
    },
    {
      name: 'unlink',
      info: 'Remover endereço',
      icon: Unlink,
      onClick: () => {
        editor.chain().focus().extendMarkRange('link').unsetLink().run()
      },
    },
  ]

  function copyLink() {
    navigator.clipboard.writeText(url)
    copied = true
    setTimeout(() => {
      copied = false
    }, 2000)
  }
</script>

<div
  class="inline-flex divide-x divide-border gap-1 items-center leading-none text-foreground"
>
  <div class="flex items-center gap-2 px-2">
    <Link class="size-4" />
    <a
      class="text-sm font-medium max-w-xs text-link underline cursor-pointer"
      href={url}
      target={editor.getAttributes('link').target}
    >
      <p class="truncate">{url}</p>
    </a>
  </div>

  <div class="flex items-center gap-2 [&>svg]:size-4 [&>svg]:cursor-pointer">
    <CopyButton {copied} handleCopy={copyLink} />

    {#each actionButtons as action (action.name)}
      <SimpleTooltip text={action.info} delay="no">
        <Button
          variant="ghost"
          size="icon"
          aria-label={action.info}
          onclick={action.onClick}
        >
          <action.icon />
        </Button>
      </SimpleTooltip>
    {/each}
  </div>
</div>

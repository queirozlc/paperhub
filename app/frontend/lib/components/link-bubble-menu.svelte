<script lang="ts">
  import { BubbleMenu, Editor } from 'svelte-tiptap'
  import LinkPreview from './link-preview.svelte'
  import LinkEditorPanel from './link-editor-panel.svelte'
  import { DEFAULT_PROTOCOL } from '$lib/constants'

  type Props = {
    editor: Editor
    editMode?: boolean
  }
  let { editor, editMode = $bindable(false) }: Props = $props()

  let url = $derived(editor.getAttributes('link').href ?? '')
  let protocol = $state(getProtocol())
  let openInNewTab = $state(editor.getAttributes('link').target === '_blank')

  function getProtocol() {
    const address = editor.getAttributes('link').href ?? ''

    if (address) {
      return `${address.split('://')[0]}://`
    }

    return DEFAULT_PROTOCOL
  }

  function handleKeyDown(e: KeyboardEvent) {
    if (e.key === 'Escape' && editMode) {
      editMode = false
    }
  }

  function editLink() {
    let address = url

    if (url.startsWith(DEFAULT_PROTOCOL)) {
      address = url.slice(DEFAULT_PROTOCOL.length)
    }

    editor
      .chain()
      .focus()
      .extendMarkRange('link')
      .setLink({
        href: `${protocol}${address}`,
        target: openInNewTab ? '_blank' : '_self',
      })
      .run()
    editMode = false
  }
</script>

<svelte:window on:keydown={handleKeyDown} />

<BubbleMenu
  class="bg-background border border-input shadow-[1px_1px_4px_rgba(0,0,0,0.1)] p-1.5 rounded w-fit max-w-[90vw] overflow-hidden"
  {editor}
  shouldShow={({ editor }) => editor.isActive('link')}
  tippyOptions={{
    placement: 'top-start',
    popperOptions: {
      modifiers: [{ name: 'flip', enabled: false, options: { padding: 10 } }],
      strategy: 'fixed',
    },
    offset: [0, 8],
    onClickOutside: () => {
      editMode = false
    },
    onHide: () => {
      editMode = false
    },
    onDestroy: () => {
      editMode = false
    },
    maxWidth: 'calc(100vw - 16px)',
  }}
>
  {#if editMode}
    <LinkEditorPanel
      onSubmit={editLink}
      bind:openInNewTab
      bind:protocol
      bind:url={
        () => url.split('://')[1],
        (updatedUrl) => {
          url = updatedUrl
        }
      }
    />
  {:else}
    <LinkPreview {editor} {url} bind:editMode />
  {/if}
</BubbleMenu>

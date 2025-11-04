<script lang="ts">
  import EditorLayout from '$layouts/EditorLayout.svelte'
  import { editorExtensions as extensions } from '$lib/extensions/extension-kit'
  import { YjsDocumentSyncer } from '$lib/sync'
  import Collaboration from '@tiptap/extension-collaboration'
  import { toUint8Array } from 'js-base64'
  import { onDestroy, onMount } from 'svelte'
  import * as Y from 'yjs'
  import type { DocumentType } from './types'
  import CollaborationCursor from '@tiptap/extension-collaboration-cursor'
  import { WebsocketProvider } from '@y-rb/actioncable'
  import { consumer } from '$lib/channels'
  import { page } from '@inertiajs/svelte'
  import { createEditor, Editor } from 'svelte-tiptap'
  import type { Readable } from 'svelte/store'
  import ToolsBubbleMenu from '$lib/components/tools-bubble-menu.svelte'
  import LinkBubbleMenu from '$lib/components/link-bubble-menu.svelte'

  let { document }: { document: DocumentType } = $props()

  let editor = $state(null) as Readable<Editor>
  let element = $state<HTMLElement | null>(null)

  const ydoc = new Y.Doc()

  const provider = new WebsocketProvider(ydoc, consumer, 'SyncChannel', {
    id: document.sqid,
  })

  // Load initial Yjs state from the server if available
  if (document.yjs_content) {
    try {
      // Decode base64 string to Uint8Array
      const bytes = toUint8Array(document.yjs_content)
      Y.applyUpdate(ydoc, bytes)
    } catch (error) {
      console.error('Error loading initial Yjs state:', error)
    }
  }

  // Initialize the document syncer
  const syncer = new YjsDocumentSyncer({
    documentId: document.sqid,
    doc: ydoc,
    debounceMs: 500,
  })

  const getRandomColor = () => {
    return '#' + Math.floor(Math.random() * 16777215).toString(16)
  }

  onMount(() => {
    editor = createEditor({
      element,
      autofocus: true,
      editorProps: {
        attributes: {
          autocomplete: 'off',
          autocorrect: 'off',
          autocapitalize: 'off',
          class: '',
        },
      },
      onCreate: ({ editor }) => {
        editor
          .chain()
          .focus()
          .setTextSelection(editor.state.doc.content.size)
          .run()
      },
      extensions: [
        ...extensions,
        Collaboration.configure({
          document: ydoc,
        }),

        CollaborationCursor.configure({
          provider,
          user: {
            name: $page.props.user.name,
            color: getRandomColor(),
          },
        }),
      ],
    })
  })

  // Cleanup on component unmount
  onDestroy(() => {
    syncer.destroy()
  })
</script>

<EditorLayout {document} editor={$editor}>
  <div
    class=" min-h-[calc(100svh-theme(spacing.10))] border border-border px-12 py-16 w-full"
  >
    <EditorContent editor={$editor} />
    {#if $editor}
      <ToolsBubbleMenu editor={$editor} />
      <LinkBubbleMenu editor={$editor} />
    {/if}
  </div>
</EditorLayout>

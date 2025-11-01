<script lang="ts">
  import EditorLayout from '$layouts/EditorLayout.svelte'
  import LinkBubbleMenu from '$lib/components/link-bubble-menu.svelte'
  import ToolsBubbleMenu from '$lib/components/tools-bubble-menu.svelte'
  import { editorExtensions as extensions } from '$lib/extensions/extension-kit'
  import { YjsDocumentSyncer } from '$lib/sync'
  import Collaboration from '@tiptap/extension-collaboration'
  import { toUint8Array } from 'js-base64'
  import { onDestroy, onMount } from 'svelte'
  import { EditorContent } from 'svelte-tiptap'
  import { Editor } from '@tiptap/core'
  import type { Readable } from 'svelte/store'
  import * as Y from 'yjs'
  import type { DocumentType } from './types'
  import CollaborationCursor from '@tiptap/extension-collaboration-cursor'
  import { WebsocketProvider } from '@y-rb/actioncable'
  import { consumer } from '$lib/channels'
  import { page } from '@inertiajs/svelte'

  let { document }: { document: DocumentType } = $props()

  let editor = $state<Editor | null>(null)
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
      console.log({ bytes })
      // Apply the server state to the local Yjs document
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
    editor = new Editor({
      element,
      autofocus: true,
      editorProps: {
        attributes: {
          autocomplete: 'off',
          autocorrect: 'off',
          autocapitalize: 'off',
          class: 'min-h-full relative',
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
    if (editor) {
      editor.destroy()
    }
  })
</script>

<EditorLayout {document} {editor}>
  <div class="flex flex-col min-h-[calc(100svh-theme(spacing.4))]">
    <div
      class="relative border border-border px-20 py-16 size-full max-w-screen-md mx-auto"
    >
      <div bind:this={element}></div>
      {#if editor}
        <!-- <ToolsBubbleMenu editor={editor} />
        <LinkBubbleMenu editor={editor} /> -->
      {/if}
    </div>
  </div>
</EditorLayout>

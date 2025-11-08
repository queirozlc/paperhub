<script lang="ts">
  import SnapshotsLayout from '$layouts/SnapshotsLayout.svelte'
  import { SnapshotDiff } from '$lib/extensions'
  import { editorExtensions } from '$lib/extensions/extension-kit'
  import { Info } from '@lucide/svelte'
  import { fromUint8Array, toUint8Array } from 'js-base64'
  import { createEditor, Editor, EditorContent } from 'svelte-tiptap'
  import type { Readable } from 'svelte/store'
  import * as Y from 'yjs'
  import type { DocumentType } from './types'
  import { onMount } from 'svelte'
  import { page, router } from '@inertiajs/svelte'
  import type { VersionSnapshot } from '$lib/extensions/snapshot-diff'
  import Collaboration from '@tiptap/extension-collaboration'
  import { ySyncPluginKey } from 'y-prosemirror'

  let {
    document,
  }: {
    document: DocumentType
  } = $props()

  let editor = $state(null) as Readable<Editor>
  let selectedVersion = $state<VersionSnapshot | null>(null)

  const user = $page.props.user

  const ydoc = new Y.Doc()

  if (document.content) {
    Y.applyUpdate(ydoc, toUint8Array(document.content))
  }

  const permanentUserData = new Y.PermanentUserData(ydoc)

  permanentUserData.setUserMapping(ydoc, ydoc.clientID, user.name)

  let versions = $derived(
    ydoc.getArray('versions').toArray()
  ) as VersionSnapshot[]

  onMount(() => {
    editor = createEditor({
      extensions: [
        ...editorExtensions,
        Collaboration.configure({
          document: ydoc,
          ySyncOptions: {
            permanentUserData,
          },
        }),
        SnapshotDiff.configure({
          doc: ydoc,
          onUpdate({ update }) {
            router.patch(
              `/documents/${document.sqid}`,
              {
                content: fromUint8Array(update),
              },
              {
                preserveState: true,
                preserveScroll: true,
                onSuccess: () => {
                  console.log('Snapshot updated successfully')
                },
                onError: (error) => {
                  console.error('Failed to update snapshot:', error)
                },
              }
            )
          },
        }),
      ],
    })
  })

  function renderVersion(version: VersionSnapshot) {
    const currentSnapshot = Y.encodeSnapshot(Y.snapshot(ydoc))

    $editor.view.dispatch(
      $editor.view.state.tr.setMeta(ySyncPluginKey, {
        snapshot: Y.decodeSnapshot(version.snapshot),
        prevSnapshot: Y.decodeSnapshot(currentSnapshot),
      })
    )

    $editor.setEditable(false)

    selectedVersion = version
  }
</script>

<SnapshotsLayout {document} editor={$editor} {ydoc}>
  <div class="flex flex-col gap-4">
    <div class="px-4">
      <h2 class="text-lg font-semibold">Snapshot Diffs (Proof of Concept)</h2>
      <p class="text-sm text-muted-foreground">
        Select a snapshot to view differences with the current document
      </p>
    </div>

    {#if !versions || versions.length === 0}
      <div class="text-center text-sm text-muted-foreground py-16">
        <p class="flex items-center gap-2 justify-center">
          <Info class="size-4" />
          <span>No snapshots yet. Create one in the editor to see it here.</span
          >
        </p>
      </div>
    {:else}
      <div class="px-4 space-y-2">
        <h3 class="text-sm font-medium">Available Snapshots</h3>
        <div class="space-y-2">
          {#each versions as version (version.clientID)}
            <button
              class="w-full text-left p-3 rounded-lg border hover:bg-accent transition-colors"
              onclick={() => renderVersion(version)}
            >
              <div class="font-medium">{version.message}</div>
              {#if version.description}
                <div class="text-sm text-muted-foreground">
                  {version.description}
                </div>
              {/if}
              <div class="text-xs text-muted-foreground mt-1">
                {new Date(version.date).toLocaleString()} by {version.author
                  ?.name}
              </div>
            </button>
          {/each}
        </div>
      </div>
    {/if}

    {#if selectedVersion}
      <div class="px-4">
        <div class="flex items-center justify-between mb-2">
          <h3 class="text-sm font-medium">
            Comparing: {selectedVersion.message} → Current
          </h3>
        </div>

        <div
          class="border border-border rounded-lg px-20 bg-background-editor py-16 relative size-full max-w-screen-md mx-auto"
        >
          {#if $editor}
            <EditorContent editor={$editor} />
          {/if}
        </div>
      </div>
    {:else}
      <div class="text-center text-sm text-muted-foreground py-16">
        <p class="flex items-center gap-2 justify-center">
          <Info class="size-4" />
          <span>Select a snapshot above to view differences</span>
        </p>
      </div>
    {/if}
  </div>
</SnapshotsLayout>

<script lang="ts">
  import DiffsLayout from '$layouts/DiffsLayout.svelte'
  import { generateHTML } from '@tiptap/core'
  import type { DocumentType, CommitType } from './types'
  import { editorExtensions } from '$lib/extensions/extension-kit'
  import { onMount } from 'svelte'
  import { createEditor, Editor, EditorContent } from 'svelte-tiptap'
  import type { Readable } from 'svelte/store'
  import { Diff } from '$lib/extensions'
  import { Icon, Info } from '@lucide/svelte'

  type Props = {
    document: DocumentType
    commits: CommitType[]
    branches: string[]
    current_branch: string
    file_content: Record<string, unknown>
  }

  let { document, branches, commits, current_branch, file_content }: Props =
    $props()

  let lastCommitHtml = ''
  let actualHtml = ''

  if (file_content && document.content) {
    lastCommitHtml = generateHTML(file_content, editorExtensions)
    actualHtml = generateHTML(document.content, editorExtensions)
  }

  let editor = $state(null) as Readable<Editor>
  let changesCount = $state(0)

  onMount(() => {
    editor = createEditor({
      autofocus: true,
      editorProps: {
        attributes: {
          autocomplete: 'off',
          autocorrect: 'off',
          autocapitalize: 'off',
          class: 'min-h-full relative',
        },
      },
      content: '',
      editable: false,
      extensions: [
        ...editorExtensions,
        Diff.configure({
          fromHTML: lastCommitHtml,
          toHTML: actualHtml,
          setDiffCount: (count: number) => {
            changesCount = count
          },
        }),
      ],
    })
  })
</script>

<DiffsLayout {document} {commits} {branches} {current_branch} {changesCount}>
  {#if lastCommitHtml && actualHtml}
    <div
      class="border border-border rounded-lg px-20 bg-background-editor py-16 relative size-full max-w-screen-md mx-auto"
    >
      <EditorContent editor={$editor} />
    </div>
  {:else}
    <div class="text-center text-sm text-muted-foreground py-16">
      <p class="flex items-center gap-2 justify-center">
        <Info class="size-4" />
        <span>Salve suas alterações para ver as diferenças</span>
      </p>
    </div>
  {/if}
</DiffsLayout>

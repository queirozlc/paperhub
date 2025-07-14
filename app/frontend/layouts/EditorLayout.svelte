<script lang="ts">
  import EditorSidebarHeader from '@/lib/components/editor-sidebar-header.svelte'
  import TableOfContents from '@/lib/components/table-of-contents.svelte'
  import TuringSidebar, { type Suggestion } from '@/lib/components/turing-sidebar.svelte'
  import * as Sidebar from '@/lib/components/ui/sidebar'
  import type { DocumentType } from '@/pages/Document/types'
  import { type Snippet } from 'svelte'

  type Props = {
    document: DocumentType
    getContent: () => string
    updateEditorWithSuggestions: (modifiedDocument: string) => void
    suggest: (suggestion: Suggestion) => void
    children: Snippet
  }

  let { children, document, getContent, updateEditorWithSuggestions, suggest }: Props = $props()

  let documentTitle = $state(document.title || 'Sem título')

  let documentTitleInput = $state(null)
</script>

<svelte:head>
  <title>
    {documentTitle}
  </title>
</svelte:head>

<div class="overflow-hidden flex max-h-dvh w-full">
  <Sidebar.Provider
    open={false}
    name="summary"
    class="w-fit overflow-hidden max-h-dvh"
  >
    <TableOfContents />
  </Sidebar.Provider>

  <Sidebar.Inset class="w-full">
    <EditorSidebarHeader
      bind:documentTitleInput
      bind:documentTitle
      {document}
    />

    <div class="flex overflow-y-scroll py-4">
      <div class="flex flex-1 flex-col gap-4 scrollbar-hidden">
        {@render children()}
      </div>
    </div>
  </Sidebar.Inset>

  <Sidebar.Provider
    name="turing"
    open={true}
    style="--sidebar-width: 18rem;"
    class="w-fit overflow-hidden max-h-dvh"
  >
    <TuringSidebar {getContent} {updateEditorWithSuggestions} {suggest} />
  </Sidebar.Provider>
</div>

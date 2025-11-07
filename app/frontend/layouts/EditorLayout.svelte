<script lang="ts">
  import EditorSidebarHeader from '$lib/components/editor-sidebar-header.svelte'
  import TableOfContents from '$lib/components/table-of-contents.svelte'
  import TuringSidebar from '$lib/components/turing-sidebar.svelte'
  import * as Sidebar from '$lib/components/ui/sidebar'
  import type { DocumentType } from '$pages/Document/types'
  import { type Snippet } from 'svelte'
  import type { Editor } from '@tiptap/core'
  import { cn } from '$lib/utils'

  type Props = {
    document: DocumentType
    editor: Editor
    children: Snippet
  }

  let { children, document, editor }: Props = $props()

  let documentTitle = $state(document.title || 'Sem título')

  let documentTitleInput = $state(null)

  let turingSidebarOpen = $state(true)
  let summarySidebarOpen = $state(false)
</script>

<svelte:head>
  <title>
    {documentTitle}
  </title>
</svelte:head>

<div class="overflow-hidden flex w-full">
  <Sidebar.Provider
    bind:open={summarySidebarOpen}
    name="summary"
    class="w-fit overflow-hidden max-h-dvh"
  >
    <Sidebar.Root transparent>
      <Sidebar.Header class="p-4">
        <p
          class="text-sm uppercase text-muted-foreground font-brand font-semibold tracking-wide"
        >
          Sumário
        </p>
      </Sidebar.Header>

      <Sidebar.Content>
        <Sidebar.Group class="space-y-2">
          <TableOfContents {editor} />
        </Sidebar.Group>
      </Sidebar.Content>
    </Sidebar.Root>
  </Sidebar.Provider>

  <Sidebar.Inset class="w-full">
    <EditorSidebarHeader
      bind:documentTitleInput
      bind:documentTitle
      {document}
      {summarySidebarOpen}
      {turingSidebarOpen}
    />

    <div
      class={cn(
        'flex w-full max-w-screen-md mx-auto gap-4 scrollbar-hidden py-6 px-4 lg:px-0',
        turingSidebarOpen && 'max-w-md lg:max-w-screen-md px-0'
      )}
    >
      {@render children()}
    </div>
  </Sidebar.Inset>

  <Sidebar.Provider
    name="turing"
    bind:open={turingSidebarOpen}
    style="--sidebar-width: 18rem;"
    class="w-fit overflow-hidden max-h-dvh"
  >
    <TuringSidebar {editor} />
  </Sidebar.Provider>
</div>

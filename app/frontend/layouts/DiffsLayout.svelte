<script lang="ts">
  import type { Snippet } from 'svelte'
  import {
    SidebarProvider,
    Sidebar,
    SidebarHeader,
    SidebarContent,
    SidebarGroup,
    SidebarInset,
  } from '$lib/components/ui/sidebar'
  import type { DocumentType } from '$pages/Document/types'
  import { EditorSidebar } from '$lib/components/documents/show/editor-header'
  import SidebarSeparator from '$lib/components/ui/sidebar/sidebar-separator.svelte'
  import { Separator } from '$lib/components/ui/separator'
  type Props = {
    children: Snippet
    document: DocumentType
  }

  let { children, document }: Props = $props()
</script>

<div class="overflow-hidden flex w-full">
  <SidebarProvider
    open={true}
    name="git-panel"
    class="w-fit overflow-hidden max-h-dvh"
  >
    <Sidebar transparent>
      <SidebarHeader class="p-4">
        <p
          class="text-sm uppercase text-muted-foreground font-brand font-semibold tracking-wide"
        >
          Diffs
        </p>
      </SidebarHeader>

      <SidebarContent>
        <SidebarGroup class="space-y-2">
          <p>Diffs</p>
        </SidebarGroup>
      </SidebarContent>
    </Sidebar>
  </SidebarProvider>

  <SidebarInset class="w-full">
    <EditorSidebar.Header>
      <EditorSidebar.Trigger for="git-panel" />
      <EditorSidebar.Tabs {document} />
      <div class="flex items-center gap-2">
        <Separator class="h-4" orientation="vertical" />
        <EditorSidebar.BranchSelect />
      </div>
    </EditorSidebar.Header>

    <div class="flex overflow-y-scroll py-4">
      <div class="flex flex-1 flex-col gap-4 scrollbar-hidden">
        {@render children()}
      </div>
    </div>
  </SidebarInset>
</div>

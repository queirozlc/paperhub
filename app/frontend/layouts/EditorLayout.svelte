<script lang="ts">
  import EditorSidebarHeader from '@/lib/components/editor-sidebar-header.svelte'
  import TableOfContents from '@/lib/components/table-of-contents.svelte'
  import TuringSidebar from '@/lib/components/turing-sidebar.svelte'
  import * as Sidebar from '@/lib/components/ui/sidebar'
  import type { ProjectType } from '@/pages/Project/types'
  import { type Snippet } from 'svelte'

  type Props = {
    project: ProjectType
    children: Snippet
  }

  let { children, project }: Props = $props()

  let projectTitle = $state(project.title || 'Sem título')

  let projectTitleInput = $state(null)
</script>

<svelte:head>
  <title>
    {projectTitle}
  </title>
</svelte:head>

<div class="overflow-hidden flex max-h-dvh w-full">
  <Sidebar.Provider name="summary" class="w-fit overflow-hidden max-h-dvh">
    <TableOfContents />
  </Sidebar.Provider>

  <Sidebar.Inset class="w-full">
    <EditorSidebarHeader bind:projectTitleInput bind:projectTitle {project} />

    <div class="flex overflow-hidden">
      <div
        class="flex flex-1 flex-col gap-4 p-4 overflow-scroll scrollbar-hidden"
      >
        {@render children()}
      </div>
    </div>
  </Sidebar.Inset>

  <Sidebar.Provider name="turing" class="w-fit overflow-hidden max-h-dvh">
    <TuringSidebar />
  </Sidebar.Provider>
</div>

<script lang="ts">
  import type { ProjectType } from '@/pages/Project/types'
  import type { Snippet } from 'svelte'
  import * as Sidebar from './ui/sidebar'

  type Props = {
    children: Snippet
    projectTitle: string
    project: ProjectType
  }

  let { projectTitle = $bindable('') }: Props = $props()
</script>

<Sidebar.Provider name="summary" class="w-fit overflow-hidden max-h-dvh">
  <Sidebar.Root transparent>
    <Sidebar.Header></Sidebar.Header>
    <Sidebar.Content>
      <Sidebar.Group class="pb-4"></Sidebar.Group>
    </Sidebar.Content>
  </Sidebar.Root>
</Sidebar.Provider>

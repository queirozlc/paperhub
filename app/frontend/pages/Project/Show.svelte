<script lang="ts">
  import type { ProjectType } from './types'

  let { project }: { project: ProjectType } = $props()
</script>

<svelte:head>
  <title>
    {project.title || 'Sem título'}
  </title>
</svelte:head>

<h1>Hello from Project - {project.title || 'Sem título'}</h1>

<script lang="ts">
  import type { ProjectType } from './types'

  let { project }: { project: ProjectType } = $props()
</script>

<div>
  <p class="my-5">
    <strong class="block font-medium mb-1">Title:</strong>
    {project.title}
  </p>
  <p class="my-5">
    <strong class="block font-medium mb-1">Description:</strong>
    {project.description}
  </p>
</div>

<script lang="ts">
  import EditorLayout from '@/layouts/EditorLayout.svelte'
  import type { ProjectType } from './types'

  let { project }: { project: ProjectType } = $props()
</script>

<EditorLayout {project}>
  <span></span>
</EditorLayout>

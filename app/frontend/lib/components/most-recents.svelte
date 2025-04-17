<script lang="ts">
  import type { ProjectType } from '@/pages/Project/types'
  import { Clock } from '@voolt_technologies/untitledui-svelte'

  type Props = {
    projects: ProjectType[]
  }

  let { projects: _projects }: Props = $props()
</script>

<div class="flex items-center gap-2 text-muted-foreground px-4">
  <Clock class="size-4" />
  <span class="text-sm font-brand font-medium pointer-events-none"
    >Mais recentes</span
  >
</div>
<section class="flex flex-col px-4"></section>

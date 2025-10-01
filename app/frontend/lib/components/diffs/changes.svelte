<script lang="ts">
  import Checkbox from '../ui/checkbox/checkbox.svelte'

  let changesCount = $state(10)
</script>

<div class="flex items-center w-full gap-2">
  <Checkbox class="shrink-0" />
  <span class="text-sm font-medium text-center flex-auto text-foreground">
    {changesCount} alterações no documento
  </span>
</div>

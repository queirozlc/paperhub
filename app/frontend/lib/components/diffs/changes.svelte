<script lang="ts">
  type Props = {
    changesCount: number
  }

  let { changesCount }: Props = $props()
</script>

<div class="flex items-center w-full gap-2">
  <span class="text-sm font-medium text-center flex-auto text-foreground">
    {changesCount} alterações no documento
  </span>
</div>

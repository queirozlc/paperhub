<script lang="ts">
  import { Separator } from '$lib/components/ui/separator'
  import { cn } from '$lib/utils'
  import type { ComponentProps } from 'svelte'

  let {
    ref = $bindable(null),
    class: className,
    ...restProps
  }: ComponentProps<typeof Separator> = $props()
</script>

<Separator
  bind:ref
  data-sidebar="separator"
  class={cn('bg-sidebar-border mx-2 w-auto', className)}
  {...restProps}
/>

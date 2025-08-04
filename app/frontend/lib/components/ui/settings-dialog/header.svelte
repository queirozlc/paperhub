<script lang="ts">
  import { cn } from '$lib/utils'
  import type { WithElementRef } from 'bits-ui'
  import type { HTMLAttributes } from 'svelte/elements'

  type Props = WithElementRef<HTMLAttributes<HTMLDivElement>>

  let { children, class: className, ref = $bindable(null) }: Props = $props()
</script>

<div bind:this={ref} class={cn('flex pb-2 flex-col gap-1', className)}>
  {@render children?.()}
</div>

<script lang="ts">
  import type { WithElementRef } from 'bits-ui'
  import type { HTMLAttributes } from 'svelte/elements'
  import { cn } from '$lib/utils'

  type Props = WithElementRef<HTMLAttributes<HTMLDivElement>>

  let { children, class: className, ref = $bindable(null) }: Props = $props()
</script>

<div bind:this={ref} class={cn('space-y-10', className)}>
  {@render children?.()}
</div>

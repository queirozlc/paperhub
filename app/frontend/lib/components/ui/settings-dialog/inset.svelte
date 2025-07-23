<script lang="ts">
  import type { WithElementRef } from 'bits-ui'
  import { cn } from '$lib/utils'
  import type { HTMLAttributes } from 'svelte/elements'

  type Props = WithElementRef<HTMLAttributes<HTMLDivElement>>

  let { children, class: className, ref = $bindable(null) }: Props = $props()
</script>

<div
  bind:this={ref}
  class={cn('flex flex-1 flex-col overflow-hidden', className)}
>
  {@render children?.()}
</div>

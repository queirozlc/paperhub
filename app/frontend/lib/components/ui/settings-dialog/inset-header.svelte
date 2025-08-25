<script lang="ts">
  import { cn } from '$lib/utils'
  import type { WithElementRef } from 'bits-ui'
  import type { HTMLAttributes } from 'svelte/elements'

  type Props = WithElementRef<HTMLAttributes<HTMLDivElement>>

  let { children, class: className, ref = $bindable(null) }: Props = $props()
</script>

<header
  class={cn(
    'flex h-16 shrink-0 items-center gap-2 transition-[width,height] ease-linear group-has-[[data-collapsible=icon]]/sidebar-wrapper:h-12',
    className
  )}
  bind:this={ref}
>
  {@render children?.()}
</header>

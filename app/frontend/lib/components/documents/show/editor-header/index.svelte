<script lang="ts">
  import type { WithElementRef } from 'bits-ui'
  import type { HTMLAttributes } from 'svelte/elements'
  import { cn } from '$lib/utils'
  type Props = WithElementRef<HTMLAttributes<HTMLDivElement>> & {
    containerProps?: HTMLAttributes<HTMLDivElement>
  }

  let {
    children,
    ref = $bindable(null),
    class: className,
    containerProps,
    ...restProps
  }: Props = $props()

  const { class: containerClass, ...containerRestProps } = containerProps || {}
</script>

<header
  bind:this={ref}
  class={cn(
    'flex min-h-14 border-sidebar-border border-b items-center px-4 justify-between',
    className
  )}
  {...restProps}
>
  <!-- Spread container props without class -->
  <div
    class={cn('flex items-center gap-2', containerClass)}
    {...containerRestProps}
  >
    {@render children?.()}
  </div>
</header>

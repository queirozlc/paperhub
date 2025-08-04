<script lang="ts">
  import { cn } from '$lib/utils'
  import type { WithElementRef } from 'bits-ui'
  import type { HTMLAttributes } from 'svelte/elements'

  let {
    class: className,
    ref = $bindable(null),
    children,
    ...props
  }: WithElementRef<HTMLAttributes<HTMLParagraphElement>> = $props()
</script>

<span
  bind:this={ref}
  class={cn('text-xs text-muted-foreground', className)}
  {...props}
>
  {@render children?.()}
</span>

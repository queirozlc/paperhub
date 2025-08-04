<script lang="ts">
  import type { WithElementRef } from 'bits-ui'
  import { cn } from '$lib/utils'
  import type { HTMLAttributes } from 'svelte/elements'

  type Props = WithElementRef<HTMLAttributes<HTMLDivElement>>

  let { children, class: className, ref = $bindable(null) }: Props = $props()
</script>

<div
  bind:this={ref}
  class={cn('w-full divide-y divide-border flex flex-col gap-4', className)}
>
  {@render children?.()}
</div>

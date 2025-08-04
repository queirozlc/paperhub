<script lang="ts">
  import { cn } from '$lib/utils'
  import type { WithElementRef } from 'bits-ui'
  import type { HTMLAttributes } from 'svelte/elements'

  type Props = WithElementRef<HTMLAttributes<HTMLHeadingElement>>

  let { children, class: className, ref = $bindable(null) }: Props = $props()
</script>

<h4 bind:this={ref} class={cn('py-2 font-brand', className)}>
  {@render children?.()}
</h4>

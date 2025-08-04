<script lang="ts">
  import { ChevronRight } from '@lucide/svelte'
  import { type WithElementRef } from 'bits-ui'
  import { cn } from '$lib/utils'
  import type { HTMLLiAttributes } from 'svelte/elements'

  let {
    ref = $bindable(null),
    class: className,
    children,
    ...restProps
  }: WithElementRef<HTMLLiAttributes> = $props()
</script>

<li
  bind:this={ref}
  data-slot="breadcrumb-separator"
  role="presentation"
  aria-hidden="true"
  class={cn('[&>svg]:size-3.5', className)}
  {...restProps}
>
  {#if children}
    {@render children?.()}
  {:else}
    <ChevronRight />
  {/if}
</li>

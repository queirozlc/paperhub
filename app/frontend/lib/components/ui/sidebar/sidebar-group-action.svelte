<script lang="ts">
  import { cn } from '$lib/utils'
  import type { WithElementRef } from 'bits-ui'
  import type { Snippet } from 'svelte'
  import type { HTMLButtonAttributes } from 'svelte/elements'

  let {
    ref = $bindable(null),
    class: className,
    showOnHover = false,
    children,
    child,
    ...restProps
  }: WithElementRef<HTMLButtonAttributes> & {
    child?: Snippet<[{ props: Record<string, unknown> }]>
    showOnHover?: boolean
  } = $props()

  const propObj = $derived({
    class: cn(
      'text-sidebar-foreground cursor-pointer ring-sidebar-ring hover:bg-sidebar-accent hover:text-sidebar-accent-foreground absolute right-3 top-3.5 flex aspect-square w-5 items-center justify-center rounded-md p-0 outline-none transition-transform focus-visible:ring-2 [&>svg]:size-4 [&>svg]:shrink-0',
      // Increases the hit area of the button on mobile.
      'after:absolute after:-inset-2 after:md:hidden',
      'group-data-[collapsible=icon]:hidden',
      showOnHover && 'opacity-0 group-hover/group-label:opacity-100',
      className
    ),
    'data-sidebar': 'group-action',
    ...restProps,
  })
</script>

{#if child}
  {@render child({ props: propObj })}
{:else}
  <button bind:this={ref} {...propObj}>
    {@render children?.()}
  </button>
{/if}

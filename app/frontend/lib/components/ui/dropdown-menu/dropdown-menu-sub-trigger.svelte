<script lang="ts">
  import { cn } from '$lib/utils'
  import { ChevronRight } from '@lucide/svelte'
  import {
    DropdownMenu as DropdownMenuPrimitive,
    type WithoutChild,
  } from 'bits-ui'

  let {
    ref = $bindable(null),
    class: className,
    inset,
    children,
    ...restProps
  }: WithoutChild<DropdownMenuPrimitive.SubTriggerProps> & {
    inset?: boolean
  } = $props()
</script>

<DropdownMenuPrimitive.SubTrigger
  bind:ref
  class={cn(
    'data-[highlighted]:bg-accent data-[state=open]:bg-accent flex cursor-default select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-none [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0',
    inset && 'pl-8',
    className
  )}
  {...restProps}
>
  {@render children?.()}
  <ChevronRight class="ml-auto" />
</DropdownMenuPrimitive.SubTrigger>

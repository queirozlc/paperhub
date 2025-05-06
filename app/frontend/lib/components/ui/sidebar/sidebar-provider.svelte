<script lang="ts">
  import * as Tooltip from '@/lib/components/ui/tooltip'
  import { cn } from '@/lib/utils'
  import type { WithElementRef } from 'bits-ui'
  import type { HTMLAttributes } from 'svelte/elements'
  import {
    SIDEBAR_COOKIE_MAX_AGE,
    SIDEBAR_COOKIE_NAME,
    SIDEBAR_WIDTH,
    SIDEBAR_WIDTH_ICON,
  } from './constants'
  import { setSidebar } from './context.svelte'
  import { getSidebarRegistry } from './registry'

  let {
    ref = $bindable(null),
    open: openProp = $bindable(true),
    onOpenChange = () => {},
    class: className,
    style,
    children,
    name = SIDEBAR_COOKIE_NAME,
    ...restProps
  }: WithElementRef<HTMLAttributes<HTMLDivElement>> & {
    open?: boolean
    onOpenChange?: (open: boolean) => void
    name?: string
  } = $props()

  const registry = getSidebarRegistry()

  let open = $derived.by(() => {
    return document.cookie
      .split('; ')
      .find((row) => row.startsWith(`${name}:state=`))
      ?.split('=')[1] === 'true'
      ? true
      : openProp
  })

  const sidebar = setSidebar({
    open: () => open,
    setOpen: (value: boolean) => {
      open = value
      onOpenChange(value)

      // This sets the cookie to keep the sidebar state.
      document.cookie = `${name}:state=${open}; path=/; max-age=${SIDEBAR_COOKIE_MAX_AGE}`
    },
  })

  registry.register(sidebar, name)
</script>

<svelte:window onkeydown={sidebar.handleShortcutKeydown} />

<Tooltip.Provider delayDuration={0} disableHoverableContent>
  <div
    style="--sidebar-width: {SIDEBAR_WIDTH}; --sidebar-width-icon: {SIDEBAR_WIDTH_ICON}; {style}"
    class={cn(
      'group/sidebar-wrapper has-[[data-variant=inset]]:bg-sidebar flex min-h-svh w-full',
      className
    )}
    bind:this={ref}
    {...restProps}
  >
    {@render children?.()}
  </div>
</Tooltip.Provider>

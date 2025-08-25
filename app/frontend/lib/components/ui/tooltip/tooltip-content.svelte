<script lang="ts">
  import { cn, getOS } from '$lib/utils'
  import { Tooltip as TooltipPrimitive } from 'bits-ui'
  import TooltipShortcut from './tooltip-shortcut.svelte'

  let {
    ref = $bindable(null),
    class: className,
    sideOffset = 4,
    shortcutKey,
    children,
    ...restProps
  }: TooltipPrimitive.ContentProps & {
    shortcutKey?: string | string[]
  } = $props()

  const isMac = getOS() === 'macos'

  function getShortcut(key: string) {
    if (key === 'Shift') return '⇧'
    if (key === 'Enter') return '↵'
    if (isMac && key === 'Mod') return '⌘'
    if (isMac && key === 'Ctrl') return '⌃'
    if (isMac && key === 'Alt') return '⌥'
    return key
  }
</script>

<TooltipPrimitive.Content
  bind:ref
  {sideOffset}
  class={cn(
    'bg-tooltip text-tooltip-foreground max-w-52 text-wrap animate-in fade-in-0 zoom-in-95 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 z-50 overflow-hidden rounded-md px-3 py-1.5 text-xs flex items-center',
    className
  )}
  {...restProps}
>
  {@render children()}
  {#if shortcutKey}
    {#if Array.isArray(shortcutKey)}
      {#each shortcutKey as key, index (index)}
        <TooltipShortcut shortcut={getShortcut(key)} class="ml-2" />
      {/each}
    {:else}
      <TooltipShortcut shortcut={getShortcut(shortcutKey)} class="ml-2" />
    {/if}
  {/if}
</TooltipPrimitive.Content>

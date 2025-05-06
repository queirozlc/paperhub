<script lang="ts">
  import { Button } from '@/lib/components/ui/button'
  import { cn } from '@/lib/utils'
  import { PanelLeft } from '@lucide/svelte'
  import type { ComponentProps } from 'svelte'
  import { getSidebarRegistry } from './registry'
  import { SIDEBAR_COOKIE_NAME } from './constants'

  let {
    ref = $bindable(null),
    class: className,
    onclick,
    for: htmlFor = SIDEBAR_COOKIE_NAME,
    ...restProps
  }: ComponentProps<typeof Button> & {
    for?: string
    onclick?: (e: MouseEvent) => void
  } = $props()

  let sidebar = $derived.by(() => {
    const registry = getSidebarRegistry()
    return registry.get(htmlFor)
  })
</script>

<Button
  type="button"
  onclick={(e: MouseEvent) => {
    onclick?.(e)
    sidebar.toggle()
  }}
  data-sidebar="trigger"
  variant="ghost"
  size="icon"
  class={cn('size-7', className)}
  {...restProps}
>
  <PanelLeft class="text-secondary-foreground" />
  <span class="sr-only">Toggle Sidebar</span>
</Button>

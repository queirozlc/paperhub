<script lang="ts">
  import { Button } from '@/lib/components/ui/button'
  import { cn } from '@/lib/utils'
  import { PanelLeft } from '@lucide/svelte'
  import type { ComponentProps } from 'svelte'
  import { useSidebar } from './context.svelte'

  let {
    ref = $bindable(null),
    class: className,
    onclick,
    ...restProps
  }: ComponentProps<typeof Button> & {
    onclick?: (e: MouseEvent) => void
  } = $props()

  const sidebar = useSidebar()
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

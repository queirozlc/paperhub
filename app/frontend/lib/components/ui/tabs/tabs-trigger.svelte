<script lang="ts">
  import { cn } from '$lib/utils'
  import { Tabs as TabsPrimitive } from 'bits-ui'

  let {
    ref = $bindable(null),
    class: className,
    value,
    ...restProps
  }: TabsPrimitive.TriggerProps = $props()
</script>

<TabsPrimitive.Trigger
  bind:ref
  data-slot="tabs-trigger"
  class={cn(
    'ring-offset-background cursor-pointer focus-visible:ring-ring data-[state=active]:bg-background/70 data-[state=active]:text-accent-foreground inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:shadow hover:bg-sidebar-accent hover:text-accent-foreground',
    className
  )}
  {value}
  {...restProps}
/>

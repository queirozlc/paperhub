<script lang="ts">
  import { cn } from '$lib/utils'
  import { Command as CommandPrimitive } from 'bits-ui'

  let {
    ref = $bindable(null),
    class: className,
    ...restProps
  }: CommandPrimitive.SeparatorProps = $props()
</script>

<CommandPrimitive.Separator
  bind:ref
  class={cn('bg-border -mx-1 h-px', className)}
  {...restProps}
/>

<script lang="ts">
  import { cn } from '$lib/utils'
  import { Command as CommandPrimitive } from 'bits-ui'

  let {
    ref = $bindable(null),
    class: className,
    ...restProps
  }: CommandPrimitive.EmptyProps = $props()
</script>

<CommandPrimitive.Empty
  bind:ref
  class={cn('py-6 text-center text-sm', className)}
  {...restProps}
/>

<script lang="ts">
  import { cn } from '$lib/utils'
  import { Dialog as SheetPrimitive } from 'bits-ui'

  let {
    ref = $bindable(null),
    class: className,
    ...restProps
  }: SheetPrimitive.DescriptionProps = $props()
</script>

<SheetPrimitive.Description
  bind:ref
  class={cn('text-muted-foreground text-sm', className)}
  {...restProps}
/>

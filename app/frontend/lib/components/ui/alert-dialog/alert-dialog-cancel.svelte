<script lang="ts">
  import { AlertDialog as AlertDialogPrimitive } from 'bits-ui'
  import { buttonVariants } from '$lib/components/ui/button/index.js'
  import { cn } from '$lib/utils'

  let {
    class: className,
    ref = $bindable(null),
    ...restProps
  }: AlertDialogPrimitive.CancelProps = $props()
</script>

<AlertDialogPrimitive.Cancel
  bind:ref
  class={cn(
    buttonVariants({ variant: 'outline', size: 'sm' }),
    'mt-2 sm:mt-0 shadow-none h-7',
    className
  )}
  {...restProps}
/>

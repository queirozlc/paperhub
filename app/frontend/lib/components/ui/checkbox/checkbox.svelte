<script lang="ts">
  import {
    Checkbox as CheckboxPrimitive,
    type WithoutChildrenOrChild,
  } from 'bits-ui'
  import { Check, Minus } from '@lucide/svelte'
  import { cn } from '$lib/utils'

  let {
    ref = $bindable(null),
    class: className,
    checked = $bindable(false),
    indeterminate = $bindable(false),
    ...restProps
  }: WithoutChildrenOrChild<CheckboxPrimitive.RootProps> = $props()
</script>

<CheckboxPrimitive.Root
  class={cn(
    'border-foreground dark:border-foreground/20 border-[1.5px] cursor-pointer focus-visible:ring-ring data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground peer box-content size-4 shrink-0 rounded focus-visible:outline-none focus-visible:ring-1 disabled:cursor-not-allowed disabled:opacity-50 data-[disabled=true]:cursor-not-allowed data-[disabled=true]:opacity-50',
    className
  )}
  bind:checked
  bind:ref
  bind:indeterminate
  {...restProps}
>
  {#snippet children({ checked, indeterminate })}
    <span class="flex items-center justify-center text-current">
      {#if indeterminate}
        <Minus class="size-4" />
      {:else}
        <Check class={cn('size-4', !checked && 'text-transparent')} />
      {/if}
    </span>
  {/snippet}
</CheckboxPrimitive.Root>

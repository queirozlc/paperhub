<script lang="ts">
  import type { SvelteHTMLElements } from 'svelte/elements'
  import { cn } from '$lib/utils'

  let {
    shortcut,
    ref = $bindable(null),
    class: className,
    ...rest
  }: { shortcut: string } & SvelteHTMLElements['kdb'] = $props()
</script>

<kbd
  bind:this={ref}
  {...rest}
  class={cn(
    'inline-flex items-center justify-center w-5 h-5 p-1 text-[0.625rem] rounded font-semibold leading-none border border-border border-b-2',
    className
  )}>{shortcut}</kbd
>

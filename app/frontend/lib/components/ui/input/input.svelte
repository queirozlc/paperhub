<script lang="ts">
  import { cn } from '$lib/utils'
  import type { WithElementRef } from 'bits-ui'
  import type { HTMLInputAttributes } from 'svelte/elements'

  type $$Props = WithElementRef<HTMLInputAttributes>

  let className: $$Props['class'] = undefined
  export let value: $$Props['value'] = undefined
  export { className as class }

  // Workaround for https://github.com/sveltejs/svelte/issues/9305
  // Fixed in Svelte 5, but not backported to 4.x.
  export let readonly: $$Props['readonly'] = undefined
</script>

<input
  class={cn(
    'border-input file:text-foreground placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground ring-ring/10 dark:ring-ring/20 dark:outline-ring/40 outline-ring/50 aria-invalid:outline-destructive/60 dark:aria-invalid:outline-destructive dark:aria-invalid:ring-destructive/40 aria-invalid:ring-destructive/20 aria-invalid:border-destructive/60 dark:aria-invalid:border-destructive flex h-9 w-full min-w-0 rounded-sm border bg-transparent px-3 py-1 text-base shadow-xs transition-all duration-100 ease-linear file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium hover:outline-1 focus-visible:ring-4 focus-visible:outline-1 disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:focus-visible:ring-[3px] aria-invalid:focus-visible:outline-none md:text-sm dark:aria-invalid:focus-visible:ring-4',
    className
  )}
  bind:value
  {readonly}
  on:blur
  on:change
  on:click
  on:focus
  on:focusin
  on:focusout
  on:keydown
  on:keypress
  on:keyup
  on:mouseover
  on:mouseenter
  on:mouseleave
  on:mousemove
  on:paste
  on:input
  on:wheel|passive
  {...$$restProps}
/>

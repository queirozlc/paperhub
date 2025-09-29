<script lang="ts">
  import type { WithElementRef } from 'bits-ui'
  import type { HTMLAttributes } from 'svelte/elements'

  type Props = {
    title?: string
    handleTitleFocusOut: () => void
    handleTitleKeydown: (event: KeyboardEvent) => void
  } & WithElementRef<HTMLAttributes<HTMLHeadingElement>>

  let {
    ref = $bindable(null),
    title,
    handleTitleFocusOut,
    handleTitleKeydown,
  }: Props = $props()
</script>

<h5
  bind:this={ref}
  class="font-brand tracking-tight text-accent-foreground max-w-md text-nowrap truncate overflow-x-auto no-scrollbar"
  contenteditable="true"
  onfocusout={handleTitleFocusOut}
  onkeydown={handleTitleKeydown}
>
  {title || 'Sem título'}
</h5>

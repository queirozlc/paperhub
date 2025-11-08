<script lang="ts">
  import { type Snippet } from 'svelte'
  import {
    TooltipProvider,
    Tooltip,
    TooltipTrigger,
    TooltipContent,
  } from '$lib/components/ui/tooltip'

  const delays = {
    no: 0,
    short: 100,
  }

  type Props = {
    text: string
    delay?: keyof typeof delays
    children: Snippet
  }

  let { text, delay = 'short', children }: Props = $props()
</script>

<TooltipProvider>
  <Tooltip delayDuration={delays[delay]} disableHoverableContent>
    <TooltipTrigger class="sm:inline-flex hidden">
      {@render children()}
    </TooltipTrigger>

    <TooltipContent>
      <span class="pointer-events-none">{text}</span>
    </TooltipContent>
  </Tooltip>
</TooltipProvider>

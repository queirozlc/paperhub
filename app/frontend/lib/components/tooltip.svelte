<script lang="ts">
  import { TooltipProvider, Tooltip, TooltipTrigger, TooltipContent } from "$lib/components/ui/tooltip";
  
  interface Props {
    text: string;
    children: import('svelte').Snippet;
  }
  
  let {
    text,
    children
  }: Props = $props();
</script>

<TooltipProvider>
  <Tooltip delayDuration={100} disableHoverableContent>
    <TooltipTrigger class="sm:inline-flex hidden">
      {@render children()}
    </TooltipTrigger>

    <TooltipContent>
      <span class="pointer-events-none">{text}</span>
    </TooltipContent>
  </Tooltip>
</TooltipProvider>
<script lang="ts">
  import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '$lib/components/ui/tooltip'
  import { Button } from '$lib/components/ui/button'
  import { CheckIcon, CopyIcon } from '@lucide/svelte'
  import { cn } from '$lib/utils'

  type Props = {
    handleCopy: () => void
    copied: boolean
  }

  let { handleCopy, copied = false }: Props = $props()
</script>

<TooltipProvider delayDuration={0} disableHoverableContent>
  <Tooltip>
    <TooltipTrigger>
      <Button
        aria-label={copied ? 'Copied' : 'Copy to clipboard'}
        class="disabled:opacity-100"
        disabled={copied}
        onclick={handleCopy}
        size="icon"
        variant="ghost"
      >
        <div
          class={cn(
            'transition-all',
            copied ? 'scale-100 opacity-100' : 'scale-0 opacity-0'
          )}
        >
          <CheckIcon aria-hidden="true" class="stroke-emerald-500" size={16} />
        </div>
        <div
          class={cn(
            'absolute transition-all',
            copied ? 'scale-0 opacity-0' : 'scale-100 opacity-100'
          )}
        >
          <CopyIcon aria-hidden="true" size={16} />
        </div>
      </Button>
    </TooltipTrigger>
    <TooltipContent class="px-2 py-1 text-xs">
      {copied ? 'Copiado' : 'Clique para copiar'}
    </TooltipContent>
  </Tooltip>
</TooltipProvider>

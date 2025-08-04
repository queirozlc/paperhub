<script lang="ts">
  import { Monitor, Moon, Sun } from '@lucide/svelte'
  import { setMode, userPrefersMode } from 'mode-watcher'
  import { cubicOut } from 'svelte/easing'
  import { Tween } from 'svelte/motion'
  import {
    Tooltip,
    TooltipContent,
    TooltipProvider,
    TooltipTrigger,
  } from '../tooltip'

  const modes = [
    {
      value: 'light',
      icon: Sun,
      tooltip: 'Claro',
    },
    {
      value: 'system',
      icon: Monitor,
      tooltip: 'Sistema',
    },
    {
      value: 'dark',
      icon: Moon,
      tooltip: 'Escuro',
    },
  ]

  const tween = new Tween(0, {
    easing: cubicOut,
    duration: 50,
  })

  function handleClick(mode: 'dark' | 'light' | 'system') {
    if (mode === 'system') {
      tween.target = 96
    } else if (mode === 'dark') {
      tween.target = 196
    } else if (mode === 'light') {
      tween.target = 0
    }

    setMode(mode)
  }
</script>

<TooltipProvider delayDuration={0} disableHoverableContent>
  <div
    class="bg-background-off border-border relative flex h-8 w-24 items-center rounded-full border p-1 shadow-inner"
    aria-label="Toggle theme"
  >
    <div
      class="bg-background-off absolute size-8 rounded-full border shadow-md top-1/2 -translate-y-1/2 left-0 transition-all duration-300"
      style="transform: translateX({tween.current}%)"
    ></div>
    <div
      class="flex h-full w-full items-center justify-between px-1 cursor-pointer"
    >
      {#each modes as mode (mode.value)}
        <Tooltip>
          <TooltipTrigger>
            {#snippet child()}
              <mode.icon
                class="text-muted-foreground z-10 size-4"
                onclick={() =>
                  handleClick(mode.value as 'dark' | 'light' | 'system')}
              />
            {/snippet}
          </TooltipTrigger>
          <TooltipContent
            class="bg-tooltip"
            side="bottom"
            align="center"
            sideOffset={10}
          >
            {mode.tooltip}
          </TooltipContent>
        </Tooltip>
      {/each}
    </div>
  </div>
</TooltipProvider>

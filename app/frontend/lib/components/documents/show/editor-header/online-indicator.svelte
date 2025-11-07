<script lang="ts">
  import AvatarStack from '$lib/components/avatar-stack.svelte'
  import { Separator } from '$lib/components/ui/separator'
  import {
    Tooltip,
    TooltipProvider,
    TooltipContent,
  } from '$lib/components/ui/tooltip'
  import { page } from '@inertiajs/svelte'

  const user = $page.props.user
</script>

<div class="lg:flex items-center gap-2 hidden">
  <Separator class="mr-2 h-4 hidden sm:block" orientation="vertical" />
  <div class="sm:flex items-center gap-1 hidden">
    <div class="size-2 rounded-full bg-green-500"></div>
    <span class="font-medium text-muted-foreground text-xs font-brand"
      >Online</span
    >
  </div>

  <TooltipProvider>
    <Tooltip delayDuration={100}>
      <AvatarStack />

      <TooltipContent>
        <span class="pointer-events-none">{user.name}</span>
      </TooltipContent>
    </Tooltip>
  </TooltipProvider>
</div>

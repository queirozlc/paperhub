<script lang="ts">
  import { cn } from '$lib/utils'
  import {
    Avatar,
    AvatarFallback,
    AvatarImage,
  } from '$lib/components/ui/avatar'
  import { Badge } from '$lib/components/ui/badge'

  type Props = {
    onProfileClick: () => void
    isActive: boolean
  }

  let { onProfileClick, isActive }: Props = $props()
</script>

<button
  class={cn(
    'flex items-center gap-2 px-2 cursor-pointer transition-colors hover:bg-sidebar-accent py-2 rounded-2xl mx-2',
    isActive && 'bg-sidebar-accent'
  )}
  onclick={onProfileClick}
>
  <Avatar>
    <AvatarImage src="https://github.com/shadcn.png" />
    <AvatarFallback>CN</AvatarFallback>
  </Avatar>

  <div class="flex flex-col gap-1">
    <h3 class="text-sm font-medium">
      <div class="flex items-center gap-2">
        <span class="text-sm font-brand font-medium">John Doe</span>
        <Badge class="rounded-full font-brand py-px">Grátis</Badge>
      </div>
      <span class="text-xs text-muted-foreground">john.doe@example.com</span>
    </h3>
  </div>
</button>

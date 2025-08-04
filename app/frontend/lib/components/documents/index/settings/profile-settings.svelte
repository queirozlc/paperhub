<script lang="ts">
  import { cn, userNameFallback } from '$lib/utils'
  import {
    Avatar,
    AvatarFallback,
    AvatarImage,
  } from '$lib/components/ui/avatar'
  import { Badge } from '$lib/components/ui/badge'
  import { page } from '@inertiajs/svelte'

  type Props = {
    onProfileClick: () => void
    isActive: boolean
  }

  let { onProfileClick, isActive }: Props = $props()

  const user = $derived($page.props.user)
</script>

<button
  class={cn(
    'flex items-center gap-1 px-2 cursor-pointer transition-colors hover:bg-sidebar-accent py-2 rounded-2xl mx-2',
    isActive && 'bg-sidebar-accent'
  )}
  onclick={onProfileClick}
>
  <Avatar class="size-6">
    <AvatarImage src={user.avatar} alt={user.name} />
    <AvatarFallback>
      {userNameFallback(user.name)}
    </AvatarFallback>
  </Avatar>

  <div class="flex items-center gap-1">
    <span class="text-sm font-brand font-medium truncate">{user.name}</span>
    <Badge class="rounded-full font-brand py-px text-xs h-4" variant="default"
      >Pemium</Badge
    >
  </div>
</button>

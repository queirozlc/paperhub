<script lang="ts">
  import type { CommitType } from '$pages/Document/types'
  import { formatDistanceToNow } from 'date-fns'
  import { ptBR } from 'date-fns/locale'
  import SidebarMenu from '../ui/sidebar/sidebar-menu.svelte'
  import { SidebarMenuItem } from '../ui/sidebar'
  import SidebarMenuButton from '../ui/sidebar/sidebar-menu-button.svelte'
  import Avatar from '../ui/avatar/avatar.svelte'
  import AvatarImage from '../ui/avatar/avatar-image.svelte'
  import { AvatarFallback } from '../ui/avatar'
  import { userNameFallback } from '$lib/utils'

  type Props = {
    commits: CommitType[]
  }

  let { commits }: Props = $props()
</script>

<SidebarMenu>
  {#each commits as commit (commit.oid)}
    <SidebarMenuItem>
      <SidebarMenuButton class="h-fit items-baseline flex flex-col gap-1">
        <span class="text-sm font-semibold">{commit.message}</span>
        <div class="flex items-center gap-2">
          <div class="flex items-center gap-0.5">
            <Avatar class="size-4">
              <AvatarImage src={commit.author.avatar} />
              <AvatarFallback>
                {userNameFallback(commit.author.name)}
              </AvatarFallback>
            </Avatar>

            <span class="text-xs text-muted-foreground font-brand truncate">
              {commit.author.name}
            </span>
          </div>

          <!-- Separator between author and time -->
          <span class="text-xs text-muted-foreground font-brand"> &bull; </span>

          <span class="text-xs text-muted-foreground font-brand"
            >{formatDistanceToNow(commit.time, {
              locale: ptBR,
              addSuffix: true,
            })}</span
          >
        </div>
      </SidebarMenuButton>
    </SidebarMenuItem>
  {/each}
</SidebarMenu>

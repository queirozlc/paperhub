<script lang="ts">
  import type { NavSecondaryItem } from '$layouts/HomeLayout.svelte'
  import {
    SidebarGroup,
    SidebarGroupContent,
    SidebarMenu,
    SidebarMenuBadge,
    SidebarMenuButton,
    SidebarMenuItem,
  } from '$lib/components/ui/sidebar'
  import { Link } from '@inertiajs/svelte'
  import { SettingsDialog } from './index'
  import { type ComponentProps } from 'svelte'
  import type { TeamType } from '$pages/Team/types'
  import type { UserInvitationType } from '$pages/Users/types'

  type Props = {
    items: NavSecondaryItem[]
    user_invitations: UserInvitationType[]
    team_members: UserInvitationType[]
    active_team: TeamType
  } & ComponentProps<typeof SidebarGroup>

  let {
    ref = $bindable(null),
    items,
    user_invitations,
    team_members,
    active_team,
    ...restProps
  }: Props = $props()

  let settingsOpen = $state(false)

  const dialogs = {
    settings: settingsDialog,
  }
</script>

{#snippet settingsDialog(
  item: NavSecondaryItem,
  props: ComponentProps<typeof SidebarMenuButton>
)}
  <SettingsDialog
    bind:open={settingsOpen}
    {item}
    {active_team}
    {user_invitations}
    {team_members}
    triggerProps={props}
  />
{/snippet}

<SidebarGroup {...restProps} bind:ref>
  <SidebarGroupContent>
    <SidebarMenu>
      {#each items as item (item.title)}
        <SidebarMenuItem class="font-semibold">
          <SidebarMenuButton>
            {#snippet child({ props })}
              {#if item.url}
                <Link href={item.url} {...props}>
                  <item.icon class="stroke-[2.5]" />
                  <span>{item.title}</span>
                </Link>
              {:else}
                {@render dialogs[item.name](item, props)}
              {/if}
            {/snippet}
          </SidebarMenuButton>
          {#if item.badge}
            <SidebarMenuBadge>{item.badge}</SidebarMenuBadge>
          {/if}
        </SidebarMenuItem>
      {/each}
    </SidebarMenu>
  </SidebarGroupContent>
</SidebarGroup>

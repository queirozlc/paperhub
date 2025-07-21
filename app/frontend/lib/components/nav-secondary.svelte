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
  import type { ComponentProps } from 'svelte'

  type Props = {
    items: NavSecondaryItem[]
  } & ComponentProps<typeof SidebarGroup>

  let { ref = $bindable(null), items, ...restProps }: Props = $props()
</script>

<SidebarGroup {...restProps} bind:ref>
  <SidebarGroupContent>
    <SidebarMenu>
      {#each items as item (item.title)}
        <SidebarMenuItem class="font-semibold">
          <SidebarMenuButton>
            {#snippet child({ props })}
              <a href={item.url} {...props}>
                <item.icon class="stroke-[2.5]" />
                <span>{item.title}</span>
              </a>
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

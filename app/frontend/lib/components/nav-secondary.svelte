<script lang="ts">
  import * as Sidebar from '$lib/components/ui/sidebar'
  import type { ComponentProps } from 'svelte'

  let {
    ref = $bindable(null),
    items,
    ...restProps
  }: ComponentProps<typeof Sidebar.Group> & {
    items: {
      title: string
      url: string
      icon: any
      badge?: string
    }[]
  } = $props()
</script>

<Sidebar.Group bind:ref {...restProps}>
  <Sidebar.GroupContent>
    <Sidebar.Menu>
      {#each items as item (item.title)}
        <Sidebar.MenuItem class="font-semibold">
          <Sidebar.MenuButton>
            {#snippet child({ props })}
              <a href={item.url} {...props}>
                <item.icon class="stroke-[2.5]" />
                <span>{item.title}</span>
              </a>
            {/snippet}
          </Sidebar.MenuButton>
          {#if item.badge}
            <Sidebar.MenuBadge>{item.badge}</Sidebar.MenuBadge>
          {/if}
        </Sidebar.MenuItem>
      {/each}
    </Sidebar.Menu>
  </Sidebar.GroupContent>
</Sidebar.Group>

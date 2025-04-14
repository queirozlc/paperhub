<script lang="ts">
  import * as Sidebar from '@/lib/components/ui/sidebar'

  let {
    items,
  }: {
    items: {
      title: string
      url: string
      // This should be `Component` after @lucide/svelte updates types
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      icon: any
      isActive?: boolean
    }[]
  } = $props()
</script>

<Sidebar.Menu>
  <Sidebar.MenuItem></Sidebar.MenuItem>

  {#each items as item (item.title)}
    <Sidebar.MenuItem class="font-semibold">
      <Sidebar.MenuButton isActive={item.isActive}>
        {#snippet child({ props })}
          <a href={item.url} {...props}>
            <item.icon />
            <span>{item.title}</span>
          </a>
        {/snippet}

        {#snippet tooltipContent()}
          <p>Hello world</p>
        {/snippet}
      </Sidebar.MenuButton>
    </Sidebar.MenuItem>
  {/each}
</Sidebar.Menu>

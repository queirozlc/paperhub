<script lang="ts">
  import * as DropdownMenu from '@/lib/components/ui/dropdown-menu'
  import * as Sidebar from '@/lib/components/ui/sidebar'
  import { ArrowUpRight, Ellipsis, Link, StarOff, Trash2 } from '@lucide/svelte'
  import { Folder, Plus } from '@voolt_technologies/untitledui-svelte'

  let {
    folders,
  }: {
    folders: {
      name: string
      url: string
      emoji: string
    }[]
  } = $props()

  const sidebar = Sidebar.useSidebar()
</script>

<Sidebar.Group class="group-data-[collapsible=icon]:hidden">
  <Sidebar.GroupLabel
    class="cursor-pointer hover:bg-sidebar-accent font-semibold text-sm gap-2"
  >
    <Folder class="size-4 text-muted-foreground [&>path]:stroke-[2.5]" />
    Pastas

    <Sidebar.GroupAction showOnHover>
      <Plus />
    </Sidebar.GroupAction>
  </Sidebar.GroupLabel>

  <Sidebar.Menu>
    {#each folders as item (item.name)}
      <Sidebar.MenuItem>
        <Sidebar.MenuButton>
          {#snippet child({ props })}
            <a href={item.url} title={item.name} {...props}>
              <span>{item.emoji}</span>
              <span>{item.name}</span>
            </a>
          {/snippet}
        </Sidebar.MenuButton>
        <DropdownMenu.Root>
          <DropdownMenu.Trigger class="cursor-pointer">
            {#snippet child({ props })}
              <Sidebar.MenuAction showOnHover {...props}>
                <Ellipsis />
                <span class="sr-only">More</span>
              </Sidebar.MenuAction>
            {/snippet}
          </DropdownMenu.Trigger>
          <DropdownMenu.Content
            class="w-56 rounded-lg"
            side={sidebar.isMobile ? 'bottom' : 'right'}
            align={sidebar.isMobile ? 'end' : 'start'}
          >
            <DropdownMenu.Item>
              <StarOff class="text-muted-foreground" />
              <span>Remove from Favorites</span>
            </DropdownMenu.Item>
            <DropdownMenu.Separator />
            <DropdownMenu.Item>
              <Link class="text-muted-foreground" />
              <span>Copy Link</span>
            </DropdownMenu.Item>
            <DropdownMenu.Item>
              <ArrowUpRight class="text-muted-foreground" />
              <span>Open in New Tab</span>
            </DropdownMenu.Item>
            <DropdownMenu.Separator />
            <DropdownMenu.Item
              class="text-destructive data-[highlighted]:bg-destructive/10 data-[highlighted]:text-destructive"
            >
              <Trash2 />
              <span>Delete</span>
            </DropdownMenu.Item>
          </DropdownMenu.Content>
        </DropdownMenu.Root>
      </Sidebar.MenuItem>
    {/each}

    {#if folders.length}
      <Sidebar.MenuItem>
        <Sidebar.MenuButton class="text-sidebar-foreground/70">
          <Ellipsis />
          <span>More</span>
        </Sidebar.MenuButton>
      </Sidebar.MenuItem>
    {/if}
  </Sidebar.Menu>
</Sidebar.Group>

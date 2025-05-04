<script lang="ts">
  import * as Sidebar from '@/lib/components/ui/sidebar'
  import { Link } from '@inertiajs/svelte'
  import { SearchSm } from '@voolt_technologies/untitledui-svelte'
  import { getOS } from '../utils'
  
  import * as Command from "@/lib/components/ui/command/index.js";
  import { Calculator, Calendar, CreditCard, Settings, Smile, User } from '@lucide/svelte'

  let {
    items,
  }: {
    items: {
      title: string
      url: string
      tooltip: string
      // This should be `Component` after @lucide/svelte updates types
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      icon: any
      isActive?: boolean
      badge?: number
    }[]
  } = $props()

  const os = getOS()

  let isSearchDialogOpen = $state(false);

  function openSearchDialog() {
    isSearchDialogOpen = true;
  }
</script>

<Sidebar.Menu>
  <Sidebar.MenuItem class="font-semibold">
    <Sidebar.MenuButton
      tooltipContentProps={{
        class: 'space-x-1',
      }}
    >
      {#snippet tooltipContent()}
        <span class="text-xs">Pesquise por projetos, tarefas e muito mais.</span
        >
        {#if os === 'macOS'}
          <kbd
            class="bg-tooltip text-tooltip-foreground pointer-events-none inline-flex h-5 select-none items-center gap-1 rounded border border-tooltip px-1.5 mt-1 font-mono text-[10px] font-medium opacity-100"
          >
            <span class="text-xs">⌘</span>K
          </kbd>
        {/if}
      {/snippet}

      {#snippet child({ props })}
        <button {...props} onclick={openSearchDialog}>
          <SearchSm />
          <span class="grow">Pesquisar</span>
        </button>
      {/snippet}
    </Sidebar.MenuButton>
  </Sidebar.MenuItem>

  <!-- Search dialog -->
  <Command.Dialog bind:open={isSearchDialogOpen}>
    <Command.Input placeholder="Type a command or search..." />
    <Command.List>
      <Command.Empty>No results found.</Command.Empty>
      <Command.Group heading="Suggestions">
        <Command.Item>
          <Calendar class="mr-2 size-4" />
          <span>Calendar</span>
        </Command.Item>
        <Command.Item>
          <Smile class="mr-2 size-4" />
          <span>Search Emoji</span>
        </Command.Item>
        <Command.Item>
          <Calculator class="mr-2 size-4" />
          <span>Calculator</span>
        </Command.Item>
      </Command.Group>
      <Command.Separator />
      <Command.Group heading="Settings">
        <Command.Item>
          <User class="mr-2 size-4" />
          <span>Profile</span>
          <Command.Shortcut>⌘P</Command.Shortcut>
        </Command.Item>
        <Command.Item>
          <CreditCard class="mr-2 size-4" />
          <span>Billing</span>
          <Command.Shortcut>⌘B</Command.Shortcut>
        </Command.Item>
        <Command.Item>
          <Settings class="mr-2 size-4" />
          <span>Settings</span>
          <Command.Shortcut>⌘S</Command.Shortcut>
        </Command.Item>
      </Command.Group>
    </Command.List>
  </Command.Dialog>

  {#each items as item (item.title)}
    <Sidebar.MenuItem class="font-semibold">
      <Sidebar.MenuButton isActive={item.isActive}>
        {#snippet tooltipContent()}
          {item.tooltip}
        {/snippet}

        {#snippet child({ props })}
          <Link href={item.url} {...props}>
            <item.icon class="[&>path]:stroke-[2.5]" />
            <span class="grow">{item.title}</span>

            {#if item.badge}
              <div
                class="bg-primary rounded-full flex items-center justify-center size-5 p-0.5"
              >
                <span class="text-xs text-primary-foreground">{item.badge}</span
                >
              </div>
            {/if}
          </Link>
        {/snippet}
      </Sidebar.MenuButton>
    </Sidebar.MenuItem>
  {/each}
</Sidebar.Menu>

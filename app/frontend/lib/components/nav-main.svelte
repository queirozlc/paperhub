<script lang="ts">
  import * as Sidebar from '@/lib/components/ui/sidebar'
  import { Link } from '@inertiajs/svelte'
  import { SearchSm } from '@voolt_technologies/untitledui-svelte'
  import { getOS } from '../utils'
  import SearchDialog from './search-dialog.svelte'

  import type { DocumentType } from '@/pages/Document/types'
  import type { NavItem } from '../models/nav-item'

  export type Item = NavItem & {
    tooltip: string
    isActive?: boolean
  }

  let {
    items,
    documents,
  }: {
    items: Item[]
    documents: DocumentType[]
  } = $props()

  const os = getOS()

  let isSearchDialogOpen = $state(false)

  function openSearchDialog() {
    isSearchDialogOpen = true
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
        <kbd
          class="bg-tooltip text-tooltip-foreground pointer-events-none inline-flex h-5 select-none items-center gap-1 rounded border border-tooltip px-1.5 mt-1 font-mono text-[10px] font-medium opacity-100"
        >
          {#if os === 'macOS'}
            <span class='text-xs'>⌘</span>K
          {:else}
            Ctrl + K
          {/if}
        </kbd>
      {/snippet}

      {#snippet child({ props })}
        <button {...props} onclick={openSearchDialog}>
          <SearchSm />
          <span class="grow">Pesquisar</span>
        </button>
      {/snippet}
    </Sidebar.MenuButton>
  </Sidebar.MenuItem>

  <SearchDialog bind:open={isSearchDialogOpen} {items} {documents} />

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

<script lang="ts">
  import * as Sidebar from '$lib/components/ui/sidebar'
  import { Link } from '@inertiajs/svelte'
  import { SearchSm } from '@voolt_technologies/untitledui-svelte'
  import { getOS } from '../utils'

  import type { NavMainItem } from '$layouts/HomeLayout.svelte'

  let { items }: { items: NavMainItem[] } = $props()

  const os = getOS()
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
        {#if os === 'macos'}
          <kbd
            class="bg-tooltip text-tooltip-foreground pointer-events-none inline-flex h-5 select-none items-center gap-1 rounded border border-tooltip px-1.5 mt-1 font-mono text-[10px] font-medium opacity-100"
          >
            <span class="text-xs">⌘</span>K
          </kbd>
        {/if}
      {/snippet}

      {#snippet child({ props })}
        <div {...props}>
          <SearchSm />
          <span class="grow">Pesquisar</span>
        </div>
      {/snippet}
    </Sidebar.MenuButton>
  </Sidebar.MenuItem>

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

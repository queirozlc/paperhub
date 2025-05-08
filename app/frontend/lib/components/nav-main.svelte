<script lang="ts">
  import * as Sidebar from '@/lib/components/ui/sidebar'
  import { Link } from '@inertiajs/svelte'
  import { SearchSm } from '@voolt_technologies/untitledui-svelte'
  import { getOS } from '../utils'
  
  import * as Command from "@/lib/components/ui/command/index.js";
  import { File } from '@lucide/svelte'
  import type { DocumentType } from '@/pages/Document/types'
  import type { TeamType } from '@/pages/Team/types'

  let {
    items, documents, teams
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
    }[],
    documents: DocumentType[],
    teams: TeamType[],
  } = $props()

  const os = getOS()

  console.log(documents);

  let isSearchDialogOpen = $state(false);
  let filteredDocs = $state(documents);
  let searchTerm = $state('');

  function openSearchDialog() {
    isSearchDialogOpen = true;
  }

  // TODO: Se inicialmente o Command.Dialog exibir TODOS os documentos,
  // pode ser interessante, ao buscar por titulo, filtrá-los via JavScript
  // ao invés de buscá-los via banco.
  // Outras buscas (como por conteúdo) precisarão ser via banco mesmo.
  function handleInput(event: Event) {
    const input = event.target as HTMLInputElement;
    searchTerm = input.value.trim();

    if (!searchTerm) {
      filteredDocs = documents;
      return;
    }

    fetch(`/documents?search=${searchTerm}`, { method: 'GET' })
      .then(res => res.json())
      .then(res => filteredDocs = res);
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
        <span class="text-xs">Pesquise por projetos, tarefas e muito mais.</span>
        {#if os === 'macOS'}
          <kbd class="bg-tooltip text-tooltip-foreground pointer-events-none inline-flex h-5 select-none items-center gap-1 rounded border border-tooltip px-1.5 mt-1 font-mono text-[10px] font-medium opacity-100">
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
  <Command.Dialog bind:open={isSearchDialogOpen} shouldFilter={false}>
    <Command.Input placeholder="Pesquise um documento ou seu conteúdo..." oninput={handleInput} />
    <Command.List>
      <Command.Empty>Nenhum resultado encontrado.</Command.Empty>
      <Command.Group heading="Deste time">
        {#each filteredDocs as doc (doc.id)}
          <Command.Item>
            <File class="size-5 text-muted-foreground" />
            <span>{ doc.title || "Sem título" }</span>
          </Command.Item>
        {/each}
      </Command.Group>
      <Command.Separator />
      <Command.Group heading="De outros times">
        <Command.Item>
          <File class="size-5 text-muted-foreground" />
          <span>TODO</span>
        </Command.Item>
      </Command.Group>
      <Command.Separator />
      <Command.Group heading="Outras opções">
        {#each items as item (item.title)}
          <Command.Item>
            <item.icon class="[&>path]:stroke-[2.5]" />
            <span class="grow">{item.title}</span>
          </Command.Item>
        {/each}
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
              <div class="bg-primary rounded-full flex items-center justify-center size-5 p-0.5">
                <span class="text-xs text-primary-foreground">{item.badge}</span>
              </div>
            {/if}
          </Link>
        {/snippet}
      </Sidebar.MenuButton>
    </Sidebar.MenuItem>
  {/each}
</Sidebar.Menu>

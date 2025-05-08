<script lang="ts">
  import * as Command from "@/lib/components/ui/command/index.js";
  import { File } from '@lucide/svelte'
  import type { DocumentType } from '@/pages/Document/types'
  import type { TeamType } from '@/pages/Team/types'
  import type { Item } from "./nav-main.svelte"

  let {
    open, items, documents, teams
  }: {
    open: boolean,
    items: Item[],
    documents: DocumentType[],
    teams: TeamType[],
  } = $props()

  console.log('times:');
  console.log(teams);

  let filteredDocs = $state(documents);
  let searchTerm = $state('');

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
  
<!-- Search dialog -->
<!-- TODO: Avaliar uso do `shouldFilter={false}` -->
<Command.Dialog bind:open>
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
    {#if teams.length > 1}
    <Command.Group heading="De outros times">
      <Command.Item>
        <File class="size-5 text-muted-foreground" />
        <span>TODO</span>
      </Command.Item>
    </Command.Group>
    <Command.Separator />
    {/if}
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
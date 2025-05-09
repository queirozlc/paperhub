<script lang="ts">
  import * as Command from "@/lib/components/ui/command/index.js";
  import { File } from '@lucide/svelte'
  import type { DocumentType } from '@/pages/Document/types'
  import type { Item } from "./nav-main.svelte"
    import { normalizeText } from "@/utils/string-utils"

  let {
    open = $bindable(false),
    items,
    documents
  }: {
    open: boolean,
    items: Item[],
    documents: DocumentType[],
  } = $props()

  let searchTerm = $state('');
  let filteredDocs = $state(documents);
  let filteredItems = $state(items);

  // TODO: Se inicialmente o Command.Dialog exibir TODOS os documentos,
  // pode ser interessante, ao buscar por titulo, filtrá-los via JavScript
  // ao invés de buscá-los via banco.
  // Outras buscas (como por conteúdo) precisarão ser via banco mesmo.
  function handleInput(event: Event) {
    const input = event.target as HTMLInputElement;
    searchTerm = normalizeText(input.value);

    if (!searchTerm) {
      filteredDocs = documents;
      filteredItems = items;
      return;
    }

    filteredItems = items.filter(item => normalizeText(item.title).includes(searchTerm));

    fetch(`/documents?search=${searchTerm}`, { method: 'GET' })
      .then(res => res.json())
      .then(res => filteredDocs = res);
  }
</script>
  
<!-- Search dialog -->
<Command.Dialog bind:open shouldFilter={false}>
  <Command.Input placeholder="Pesquise um documento ou seu conteúdo..." oninput={handleInput} />
  <Command.List>
    <Command.Empty>Nenhum resultado encontrado.</Command.Empty>
    <Command.Group heading="Documentos">
      {#each filteredDocs as doc (doc.id)}
        <Command.Item>
          <File class="size-5 text-muted-foreground" />
          <span>{ doc.title || "Sem título" }</span>
        </Command.Item>
      {/each}
    </Command.Group>
    <Command.Separator />
    <!--
    {#if teams.length > 1}
      <Command.Group heading="De outros times">
        <Command.Item>
          <File class="size-5 text-muted-foreground" />
          <span>TODO</span>
        </Command.Item>
      </Command.Group>
      <Command.Separator />
    {/if}
    -->
    <Command.Group heading="Outras opções">
      {#each filteredItems as item (item.title)}
        <Command.Item>
          <item.icon class="[&>path]:stroke-[2.5]" />
          <span class="grow">{item.title}</span>
        </Command.Item>
      {/each}
    </Command.Group>
  </Command.List>
</Command.Dialog>
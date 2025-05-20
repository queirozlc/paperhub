<script lang="ts">
  import * as Command from '@/lib/components/ui/command/index.js'
  import { File } from '@lucide/svelte'
  import type { DocumentType } from '@/pages/Document/types'
  import type { Item } from './nav-main.svelte'
  import { normalizeText } from '@/lib/utils'

  let {
    open = $bindable(false),
    items,
    documents,
  }: {
    open: boolean
    items: Item[]
    documents: DocumentType[]
  } = $props()

  let searchTerm = $state('')
  let filteredDocs = $state(documents)
  let filteredItems = $state(items)

  function handleInput(event: Event) {
    const input = event.target as HTMLInputElement
    searchTerm = normalizeText(input.value)

    if (!searchTerm) {
      filteredDocs = documents
      filteredItems = items
      return
    }

    filteredItems = items.filter((item) =>
      normalizeText(item.title).includes(searchTerm)
    )

    fetch(`/documents?search=${searchTerm}`, { method: 'GET' })
      .then((res) => res.json())
      .then((res) => (filteredDocs = res))
  }
</script>

<!-- Search dialog -->
<Command.Dialog bind:open shouldFilter={false}>
  <Command.Input
    placeholder="Pesquise um documento ou seu conteúdo..."
    oninput={handleInput}
  />
  <Command.List>
    <Command.Empty>Nenhum resultado encontrado.</Command.Empty>
    <Command.Group heading="Documentos">
      {#each filteredDocs as doc (doc.id)}
        <Command.Item>
          <File class="size-5 text-muted-foreground" />
          <span>{doc.title || 'Sem título'}</span>
        </Command.Item>
      {/each}
    </Command.Group>
    <Command.Separator />
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

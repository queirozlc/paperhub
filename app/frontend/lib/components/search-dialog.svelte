<script lang="ts">
  import * as Command from '@/lib/components/ui/command/index.js'
  import { File } from '@lucide/svelte'
  import type { DocumentType } from '@/pages/Document/types'
  import type { Item } from './nav-main.svelte'
  import { router } from '@inertiajs/svelte'
  import { normalize } from '../utils'

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
  
  let filteredItems = $derived.by(() => {
    if (!searchTerm.trim()) {
      return items
    }
    return items.filter(({ title }) => 
      normalize(title).includes(normalize(searchTerm))
    )
  })

  // Search for documents
  $effect(() => {
    const searchUrl = searchTerm
      ? `/documents?search=${encodeURIComponent(searchTerm)}`
      : '/documents'

    router.visit(searchUrl, {
      preserveState: true,
      preserveScroll: true,
      replace: true,
    })
  })

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === 'k' && (event.ctrlKey || event.metaKey)) {
      event.preventDefault()
      open = !open
    }
  }
</script>

<svelte:window onkeydown={handleKeydown} />

<!-- Search dialog -->
<Command.Dialog
  bind:open
  shouldFilter={false}
  onOpenChange={() => (searchTerm = '')}
>
  <Command.Input
    placeholder="Pesquise um documento ou seu conteúdo..."
    bind:value={searchTerm}
  />

  <Command.List>

    <Command.Empty>Nenhum resultado encontrado.</Command.Empty>

    {#if documents.length > 0}
    <Command.Group heading="Documentos">
      {#each documents as doc (doc.id)}
        <Command.Item class="cursor-pointer">
          <File class="size-5 text-muted-foreground" />
          <span>{doc.title || 'Sem título'}</span>
        </Command.Item>
      {/each}
    </Command.Group>
    {/if}

    <Command.Separator />
    {#if filteredItems.length > 0}
    <Command.Group heading="Outras opções">
      {#each filteredItems as item (item.title)}
        <Command.Item class="cursor-pointer">
          <item.icon class="[&>path]:stroke-[2.5]" />
          <span class="grow">{item.title}</span>
        </Command.Item>
      {/each}
    </Command.Group>
    {/if}
    
  </Command.List>
</Command.Dialog>

<script lang="ts">
  import {
    AlertDialog,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogRemove,
    AlertDialogTitle,
    AlertDialogTrigger,
  } from '@/lib/components/ui/alert-dialog'
  import Checkbox from '@/lib/components/ui/checkbox/checkbox.svelte'
  import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuTrigger,
  } from '@/lib/components/ui/dropdown-menu'
  import { Separator } from '@/lib/components/ui/separator'
  import { Link, router } from '@inertiajs/svelte'
  import { ListChecks } from '@lucide/svelte'
  import {
    DotsVertical,
    File06 as File,
    Trash01,
    X,
  } from '@voolt_technologies/untitledui-svelte'
  import { formatDistanceToNowStrict } from 'date-fns'
  import { ptBR } from 'date-fns/locale'
  import type { DocumentType } from './types'

  type Props = {
    documents: DocumentType[]
  }

  let { documents }: Props = $props()

  const daysAgo = (date: Date) =>
    formatDistanceToNowStrict(date, {
      locale: ptBR,
      roundingMethod: 'ceil',
    })

  let editMode = $state(false)
  let selectedDocuments: number[] = $state([])
  let openBulkDelete = $state(false)

  function toggleCheck(isChecked: boolean) {
    if (isChecked) {
      selectedDocuments = documents.map((doc) => doc.id)
    } else {
      selectedDocuments = []
    }

    return selectedDocuments.length === documents.length
  }

  function toggleSelect(isChecked: boolean, id: number) {
    if (isChecked) {
      selectedDocuments.push(id)
    } else {
      selectedDocuments = selectedDocuments.filter(
        (documentId) => documentId !== id
      )
    }

    return selectedDocuments.includes(id)
  }

  function resetEditMode() {
    editMode = false
    selectedDocuments = []
    openBulkDelete = false
  }

  function removeDocument(hashId: string) {
    router.delete(`/documents/${hashId}`, {
      preserveState: true,
      preserveScroll: true,
    })
  }

  function destroyAll() {
    router.delete('/documents', {
      data: {
        ids: selectedDocuments,
      },
    })

    resetEditMode()
  }

  const handleKeydown = (e: KeyboardEvent) => {
    if (e.key === 'Escape') resetEditMode()
  }
</script>

<svelte:window onkeydown={handleKeydown} />

<!-- Grid Container -->
<div class="mt-5 grid grid-cols-[1fr_auto_auto_100px] px-4">
  <!-- Header -->
  <div class="flex items-center gap-5 text-accent-foreground">
    {#if editMode}
      <Checkbox
        class="size-3 flex items-center rounded justify-center [&>span>svg]:size-3"
        bind:checked={
          () => selectedDocuments.length === documents.length,
          (isChecked) => toggleCheck(isChecked)
        }
      />
    {/if}
    <div
      class="flex items-center gap-5 cursor-pointer hover:text-accent-foreground/70"
    >
      <ListChecks
        class="size-4 cursor-pointer hover:text-accent-foreground/70"
        onclick={() => (editMode = !editMode)}
      />
      <span class="font-brand text-sm font-medium">Título</span>
    </div>
  </div>

  <div class="flex items-center gap-4 text-sm font-brand font-medium">
    <span class="cursor-pointer hover:text-accent-foreground/70">Criado em</span
    >

    <Separator orientation="vertical" class="h-4" />

    <span class="cursor-pointer hover:text-accent-foreground/70"
      >Última edição</span
    >
  </div>
</div>

<div class="mt-2 space-y-1">
  {#each documents as document (document.id)}
    <Link
      href={`/documents/${document.sqid}`}
      class="grid grid-cols-[1fr_auto_auto] items-center hover:bg-muted py-2 px-4 rounded cursor-pointer"
    >
      <div class="flex items-center gap-4">
        {#if editMode}
          <Checkbox
            bind:checked={
              () => selectedDocuments.includes(document.id),
              (isChecked) => toggleSelect(isChecked, document.id)
            }
          />
        {/if}
        <File class="size-5 text-muted-foreground" />
        <div class="font-brand flex flex-col font-semibold max-w-60">
          <span class="text-accent-foreground text-sm">
            {document.title || 'Sem título'}
          </span>

          <span class="text-muted-foreground text-xs font-medium truncate">
            {document.description || 'Lorem ipsum solar sit amet...'}
          </span>
        </div>
      </div>

      <div
        class="grid grid-cols-[100px_100px_3.5rem] text-sm font-brand font-medium gap-4 pr-2 text-right"
      >
        <span class="text-accent-foreground tabular-nums">
          {daysAgo(new Date(document.created_at))}
        </span>
        <span class="text-accent-foreground">
          {daysAgo(new Date(document.updated_at))}
        </span>
      </div>

      <AlertDialog>
        <DropdownMenu>
          <DropdownMenuTrigger
            class="cursor-pointer p-1 hover:bg-sidebar-accent rounded-md"
          >
            <DotsVertical class="size-4 text-accent-foreground" />
          </DropdownMenuTrigger>

          <DropdownMenuContent class="mr-2">
            <AlertDialogTrigger>
              <DropdownMenuItem
                class="text-destructive data-[highlighted]:bg-destructive/10 data-[highlighted]:text-destructive"
              >
                <Trash01 />
                <span class="font-medium font-brand"> Mover para lixeira </span>
              </DropdownMenuItem>
            </AlertDialogTrigger>
          </DropdownMenuContent>
        </DropdownMenu>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Tem certeza disso?</AlertDialogTitle>
            <AlertDialogDescription>
              Você está prestes a mover o documento <strong
                >{document.title}</strong
              > para a lixeira. Isso significa que você não poderá acessá-lo até
              que o restaure. Você tem certeza de que deseja continuar?
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter class="gap-4">
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogRemove onclick={() => removeDocument(document.sqid)}
              >Remover</AlertDialogRemove
            >
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </Link>
  {/each}
</div>

<AlertDialog
  open={openBulkDelete}
  onOpenChange={() => (openBulkDelete = !openBulkDelete)}
>
  {#if editMode}
    <div
      class="flex absolute bottom-4 items-center border border-border gap-4 bg-background/70 rounded-md px-4 py-2 shadow-[1px_1px_4px_1px_rgba(0,0,0,0.1)] left-1/2 -translate-x-1/2 -translate-y-1/2"
    >
      <span class="text-sm font-brand font-medium text-accent-foreground">
        {selectedDocuments.length} documento(s) selecionados
      </span>

      <div class="flex items-center gap-2">
        <button
          class="hover:bg-muted rounded p-1.5 transition-colors duration-75 cursor-pointer"
          onclick={resetEditMode}
        >
          <X class="size-5" />
        </button>
        <Separator orientation="vertical" class="h-4" />
        <AlertDialogTrigger>
          <button
            class="cursor-pointer hover:bg-destructive/20 transition-colors duration-75 rounded p-1.5 disabled:opacity-45 disabled:cursor-not-allowed"
            disabled={selectedDocuments.length === 0}
          >
            <Trash01 class="size-5 text-destructive" />
          </button>
        </AlertDialogTrigger>
      </div>
    </div>
  {/if}

  <AlertDialogContent>
    <AlertDialogHeader>
      <AlertDialogTitle>Tem certeza disso?</AlertDialogTitle>
      <AlertDialogDescription>
        Você está prestes a mover {selectedDocuments.length} documento(s) para a
        lixeira. Isso significa que você não poderá acessá-lo até que o restaure.
        Você tem certeza de que deseja continuar?
      </AlertDialogDescription>
    </AlertDialogHeader>
    <AlertDialogFooter class="gap-4">
      <AlertDialogCancel>Cancelar</AlertDialogCancel>
      <AlertDialogRemove onclick={destroyAll}>Remover</AlertDialogRemove>
    </AlertDialogFooter>
  </AlertDialogContent>
</AlertDialog>

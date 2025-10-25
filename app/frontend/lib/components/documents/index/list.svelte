<script lang="ts">
  import { Checkbox } from '$lib/components/ui/checkbox'
  import { File } from '@lucide/svelte'
  import { DotsVertical, Trash01 } from '@voolt_technologies/untitledui-svelte'
  import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuTrigger,
  } from '$lib/components/ui/dropdown-menu'
  import {
    AlertDialog,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
    AlertDialogCancel,
    AlertDialogRemove,
    AlertDialogTrigger,
  } from '$lib/components/ui/alert-dialog'
  import type { DocumentType } from '$pages/Document/types'
  import { formatDistanceToNowStrict } from 'date-fns'
  import { ptBR } from 'date-fns/locale'
  import { router } from '@inertiajs/svelte'
  type Props = {
    document: DocumentType
    editMode: boolean
    selectedDocuments: number[]
  }

  let {
    document,
    editMode,
    selectedDocuments = $bindable([]),
  }: Props = $props()

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

  const daysAgo = (date: Date) =>
    formatDistanceToNowStrict(date, {
      locale: ptBR,
      roundingMethod: 'ceil',
    })

  function removeDocument(hashId: string) {
    router.delete(`/documents/${hashId}`, {
      preserveState: true,
      preserveScroll: true,
    })
  }
</script>

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
      {document.description || ''}
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
        Você está prestes a mover o documento <strong>{document.title}</strong> para
        a lixeira. Isso significa que você não poderá acessá-lo até que o restaure.
        Você tem certeza de que deseja continuar?
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

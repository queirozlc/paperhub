<script lang="ts">
  import type { DocumentType } from '$pages/Document/types'
  import { ListChecks } from '@lucide/svelte'
  import { Checkbox } from '$lib/components/ui/checkbox'
  import { Separator } from '$lib/components/ui/separator'

  type Props = {
    editMode: boolean
    selectedDocuments: number[]
    documents: DocumentType[]
  }

  let { editMode, documents, selectedDocuments }: Props = $props()

  function toggleCheck(isChecked: boolean) {
    if (isChecked) {
      selectedDocuments = documents.map((doc) => doc.id)
    } else {
      selectedDocuments = []
    }

    return selectedDocuments.length === documents.length
  }
</script>

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

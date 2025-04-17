<script lang="ts">
  import { ListChecks } from '@lucide/svelte'
  import type { ProjectType } from './types'
  import { Separator } from '@/lib/components/ui/separator'
  import {
    DotsVertical,
    File06 as File,
    Trash01,
    X,
  } from '@voolt_technologies/untitledui-svelte'
  import { formatDistanceToNowStrict } from 'date-fns'
  import { ptBR } from 'date-fns/locale'
  import {
    DropdownMenu,
    DropdownMenuTrigger,
  } from '@/lib/components/ui/dropdown-menu'
  import Checkbox from '@/lib/components/ui/checkbox/checkbox.svelte'
  import { onMount } from 'svelte'
  import { router } from '@inertiajs/svelte'

  let { projects }: { projects: ProjectType[] } = $props()

  const daysAgo = (date: Date) =>
    formatDistanceToNowStrict(date, {
      locale: ptBR,
      roundingMethod: 'ceil',
    })

  let editMode = $state(false)
  let selectedProjects: number[] = $state([])

  function toggleCheck(isChecked: boolean) {
    if (isChecked) {
      selectedProjects = projects.map((project) => project.id)
    } else {
      selectedProjects = []
    }

    return selectedProjects.length === projects.length
  }

  function toggleSelect(isChecked: boolean, id: number) {
    if (isChecked) {
      selectedProjects.push(id)
    } else {
      selectedProjects = selectedProjects.filter(
        (projectId) => projectId !== id
      )
    }

    return selectedProjects.includes(id)
  }

  function resetEditMode() {
    editMode = false
    selectedProjects = []
  }

  onMount(() => {
    const handleKeydown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') resetEditMode()
    }

    document.addEventListener('keydown', handleKeydown)

    return () => {
      document.removeEventListener('keydown', handleKeydown)
    }
  })
</script>

<!-- Grid Container -->
<div class="mt-5 grid grid-cols-[1fr_auto_auto_100px] px-4">
  <!-- Header -->
  <div class="flex items-center gap-5 text-accent-foreground">
    {#if editMode}
      <Checkbox
        class="size-3 flex items-center rounded justify-center [&>span>svg]:size-3"
        bind:checked={
          () => selectedProjects.length === projects.length,
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
  {#each projects as project (project.id)}
    <div
      class="grid grid-cols-[1fr_auto_auto] items-center hover:bg-muted py-2 px-4 rounded cursor-pointer"
    >
      <div class="flex items-center gap-4">
        {#if editMode}
          <Checkbox
            bind:checked={
              () => selectedProjects.includes(project.id),
              (isChecked) => toggleSelect(isChecked, project.id)
            }
          />
        {/if}
        <File class="size-5 text-muted-foreground" />
        <div class="font-brand flex flex-col font-semibold max-w-60">
          <span class="text-accent-foreground text-sm">
            {project.title || 'Sem título'}
          </span>

          <span class="text-muted-foreground text-xs font-medium truncate">
            {project.description || 'Lorem ipsum solar sit amet...'}
          </span>
        </div>
      </div>

      <div
        class="grid grid-cols-[100px_100px_3.5rem] text-sm font-brand font-medium gap-4 pr-2 text-right"
      >
        <span class="text-accent-foreground tabular-nums">
          {daysAgo(new Date(project.created_at))}
        </span>
        <span class="text-accent-foreground">
          {daysAgo(new Date(project.updated_at))}
        </span>
      </div>

      <DropdownMenu>
        <DropdownMenuTrigger
          class="cursor-pointer p-1 hover:bg-sidebar-accent rounded-md"
        >
          <DotsVertical class="size-4 text-accent-foreground" />
        </DropdownMenuTrigger>
      </DropdownMenu>
    </div>
  {/each}
  <!-- Align in center -->
</div>

{#if editMode}
  <div
    class="flex absolute bottom-4 items-center border border-border gap-4 bg-background rounded-md px-4 py-2 shadow-[1px_1px_4px_1px_rgba(0,0,0,0.1)] left-1/2 -translate-x-1/2 -translate-y-1/2"
  >
    <span class="text-sm font-brand font-medium text-accent-foreground">
      {selectedProjects.length} projeto(s) selecionados
    </span>

    <div class="flex items-center gap-2">
      <button
        class="hover:bg-muted rounded p-1.5 transition-colors duration-75 cursor-pointer"
        onclick={resetEditMode}
      >
        <X class="size-5" />
      </button>
      <Separator orientation="vertical" class="h-4" />
      <div
        class="cursor-pointer hover:bg-destructive/20 transition-colors duration-75 rounded p-1.5"
      >
        <Trash01 class="size-5 text-destructive" />
      </div>
    </div>
  </div>
{/if}

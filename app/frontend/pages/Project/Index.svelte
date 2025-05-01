<script module>
  import emptyDark from '@/assets/images/empty-dark.png'
  import empty from '@/assets/images/empty.png'
</script>

<script lang="ts">
  import HomeLayout from '@/layouts/HomeLayout.svelte'
  import MostRecents from '@/lib/components/most-recents.svelte'
  import Button from '@/lib/components/ui/button/button.svelte'
  import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuTrigger,
  } from '@/lib/components/ui/dropdown-menu'
  import { router } from '@inertiajs/svelte'
  import { Blocks, FileStack } from '@lucide/svelte'
  import { ChevronDown, File02 } from '@voolt_technologies/untitledui-svelte'
  import Project from './Project.svelte'
  import type { ProjectType } from './types'
  import type { TeamType } from '../Team/types'

  type Props = {
    projects: ProjectType[]
    teams: TeamType[]
  }

  let { projects, teams }: Props = $props()

  function newProject(params = { title: '', description: '' }) {
    router.post('/projects', {
      project: params,
    })
  }
</script>

<HomeLayout {projects} {teams}>
  <MostRecents />

  <div class="flex items-center justify-between px-4">
    <h5 class="font-brand text-muted-foreground font-medium">Seus Projetos</h5>
    <DropdownMenu>
      <DropdownMenuTrigger>
        <Button size="sm" class="shadow-none gap-1" variant="outline">
          Criar Projeto
          <ChevronDown class="size-4" />
        </Button>
      </DropdownMenuTrigger>

      <DropdownMenuContent class="w-56 space-y-1.5">
        <DropdownMenuItem
          class="border border-input"
          onclick={() => newProject()}
        >
          <div class="flex items-center justify-between w-full px-1">
            <div class="text-sm font-brand flex flex-col">
              <span class="font-medium text-accent-foreground">Nova página</span
              >
              <span class="text-xs text-muted-foreground max-w-[90%]"
                >Crie um novo projeto em branco</span
              >
            </div>

            <File02 class="text-accent-foreground size-5" />
          </div>
        </DropdownMenuItem>

        <DropdownMenuItem class="border border-input">
          <div class="flex items-center justify-between w-full px-1">
            <div class="text-sm font-brand flex flex-col">
              <span class="font-medium text-accent-foreground">
                Usar modelo
              </span>
              <span class="text-xs text-muted-foreground max-w-[90%]"
                >Crie um novo projeto a partir de um modelo</span
              >
            </div>

            <Blocks class="text-accent-foreground size-7" />
          </div>
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  </div>

  {#if projects.length}
    <Project {projects} />
  {:else}
    <div class="h-full w-full flex items-center justify-center">
      <div class="flex flex-col items-center gap-2">
        <img src={empty} alt="Sem projetos" class="dark:hidden w-60" />
        <img
          src={emptyDark}
          alt="Sem projetos"
          class="w-60 hidden dark:block"
        />
        <p class="text-sm text-muted-foreground">
          Você não tem nenhum projeto ainda.
        </p>
        <Button
          variant="outline"
          size="sm"
          class="gap-1"
          onclick={() => newProject()}
        >
          <FileStack class="size-4" />
          Criar novo Projeto
        </Button>
      </div>
    </div>
  {/if}
</HomeLayout>

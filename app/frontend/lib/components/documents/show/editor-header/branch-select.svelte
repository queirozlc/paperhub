<script lang="ts">
  import Badge from '$lib/components/ui/badge/badge.svelte'
  import { Button } from '$lib/components/ui/button'
  import { type ButtonProps } from '$lib/components/ui/button/button.svelte'
  import {
    Command,
    CommandEmpty,
    CommandGroup,
    CommandInput,
    CommandItem,
    CommandList,
  } from '$lib/components/ui/command'

  import {
    Popover,
    PopoverContent,
    PopoverTrigger,
  } from '$lib/components/ui/popover'
  import Separator from '$lib/components/ui/separator/separator.svelte'
  import {
    Tooltip,
    TooltipContent,
    TooltipProvider,
    TooltipTrigger,
  } from '$lib/components/ui/tooltip'
  import { cn } from '$lib/utils'
  import { Link, router } from '@inertiajs/svelte'

  import { ChevronDown, GitBranch, LoaderIcon, Plus } from '@lucide/svelte'

  type Props = ButtonProps & {
    branches: string[]
    document_id: string
    current_branch: string
    createBranch: (name: string, target: string) => void
  }

  const {
    ref = $bindable(null),
    class: className,
    branches,
    document_id,
    current_branch,
    createBranch,
    ...restProps
  }: Props = $props()

  function reloadBranches() {
    router.reload({
      only: ['branches'],
    })
  }

  let actualBranch = $derived(current_branch)
  let shouldHideCreateBranch = $state(false)
  let filterTerm = $state('')
</script>

<Popover>
  <PopoverTrigger>
    <Button
      variant="outline"
      size="lg"
      {ref}
      class={cn('w-full px-3 h-11', className)}
      {...restProps}
    >
      <div class="flex items-center justify-between w-full gap-8">
        <div class="flex items-center gap-2">
          <GitBranch class="size-4" />
          <div class="flex flex-col items-start">
            <span class="text-[10px] text-muted-foreground">Branch Atual</span>
            <span class="text-xs text-accent-foreground">{actualBranch}</span>
          </div>
        </div>
        <ChevronDown class="size-4" />
      </div>
    </Button>
  </PopoverTrigger>

  <PopoverContent class="p-0" align="start">
    <Command
      value={actualBranch}
      onStateChange={({ search, filtered }) => {
        if (!branches) {
          reloadBranches()
          return
        }
        filterTerm = search
        shouldHideCreateBranch = filtered.items
          .entries()
          .filter(([key]) => branches?.some((branch) => branch === key))
          .some(([, value]) => value === 1)
      }}
    >
      <CommandInput
        placeholder="Pesquisar ou criar branch..."
        class="h-10 text-sm"
      />
      <CommandList>
        <CommandEmpty class="flex items-center justify-center h-full">
          {#if branches}
            <span class="text-sm text-muted-foreground">
              Nenhuma branch encontrada
            </span>
          {:else}
            <LoaderIcon class="size-5 animate-spin mx-auto" />
          {/if}
        </CommandEmpty>
        <CommandGroup>
          {#each branches as branch (branch)}
            <Link href={`/documents/${document_id}/diffs/${branch}`}>
              <CommandItem
                value={branch}
                onSelect={() => {
                  actualBranch = branch
                }}
                class={cn(
                  'cursor-pointer my-1 text-muted-foreground justify-between',
                  {
                    'text-foreground font-semibold bg-accent':
                      branch === actualBranch,
                  }
                )}
              >
                {@const Icon = GitBranch}
                <div class="flex items-center gap-2">
                  <Icon class="mr-2 size-4" />

                  <span>
                    {branch}
                  </span>
                </div>

                {#if branch === 'main' || branch === 'master'}
                  <Badge class="px-1 py-0 text-xs font-medium font-brand"
                    >Padrão</Badge
                  >
                {/if}
              </CommandItem>
            </Link>
          {/each}
        </CommandGroup>
      </CommandList>
    </Command>

    {#if !shouldHideCreateBranch && filterTerm && filterTerm.length > 1}
      <Separator class="mt-2" orientation="horizontal" />
      <TooltipProvider>
        <Tooltip>
          <TooltipTrigger>
            {#snippet child({ props })}
              <div class="p-2">
                <Button
                  variant="ghost"
                  class="w-full h-8"
                  {...props}
                  onclick={() => createBranch(filterTerm, actualBranch)}
                >
                  <Plus class="size-4" />
                  <span class="text-xs truncate text-ellipsis"
                    >Criar branch <span class="font-bold">{filterTerm}</span> a
                    partir da branch
                    <span class="font-bold">{actualBranch}</span></span
                  >
                </Button>
              </div>
            {/snippet}
          </TooltipTrigger>

          <TooltipContent class="inline-block" side="right">
            Criar branch <span class="font-bold">{filterTerm}</span> a partir da
            branch <span class="font-bold">{actualBranch}</span>
          </TooltipContent>
        </Tooltip>
      </TooltipProvider>
    {/if}
  </PopoverContent>
</Popover>

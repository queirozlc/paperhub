<script lang="ts">
  import Badge from '$lib/components/ui/badge/badge.svelte'
  import { Button } from '$lib/components/ui/button'
  import { type ButtonProps } from '$lib/components/ui/button/button.svelte'
  import {
    CommandEmpty,
    CommandInput,
    CommandList,
    CommandGroup,
    CommandItem,
    Command,
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
  import { ChevronDown, GitBranch, Plus } from '@lucide/svelte'

  const {
    ref = $bindable(null),
    class: className,
    ...restProps
  }: ButtonProps = $props()

  let fakeBranches = $state([
    {
      id: 1,
      name: 'main',
      description: 'Main branch',
      default: true,
    },
    {
      id: 2,
      name: 'feature/test',
      description: 'Test branch',
      default: false,
    },

    {
      id: 3,
      name: 'feature/test3',
      description: 'Test branch',
      default: false,
    },
  ])

  let actualBranch = $state(fakeBranches[0])
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
            <span class="text-xs text-accent-foreground"
              >{actualBranch.name}</span
            >
          </div>
        </div>
        <ChevronDown class="size-4" />
      </div>
    </Button>
  </PopoverTrigger>

  <PopoverContent class="p-0" align="start">
    <Command
      value={actualBranch.name}
      onStateChange={({ search, filtered }) => {
        filterTerm = search
        shouldHideCreateBranch = filtered.items
          .entries()
          .filter(([key]) => fakeBranches.some((branch) => branch.name === key))
          .some(([, value]) => value === 1)
      }}
    >
      <CommandInput
        placeholder="Pesquisar ou criar branch..."
        class="h-10 text-sm"
      />
      <CommandList>
        <CommandEmpty class="text-sm text-muted-foreground">
          Nenhuma branch encontrada
        </CommandEmpty>
        <CommandGroup>
          {#each fakeBranches as branch (branch.id)}
            <CommandItem
              value={branch.name}
              onSelect={() => {
                actualBranch = branch
              }}
              class={cn(
                'cursor-pointer my-1 text-muted-foreground justify-between',
                {
                  'text-foreground font-semibold bg-accent':
                    branch.id === actualBranch.id,
                }
              )}
            >
              {@const Icon = GitBranch}
              <div class="flex items-center gap-2">
                <Icon class="mr-2 size-4" />

                <span>
                  {branch.name}
                </span>
              </div>

              {#if branch.default}
                <Badge class="px-1 py-0 text-xs font-medium font-brand"
                  >Padrão</Badge
                >
              {/if}
            </CommandItem>
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
                <Button variant="ghost" class="w-full h-8" {...props}>
                  <Plus class="size-4" />
                  <span class="text-xs truncate text-ellipsis"
                    >Criar branch <span class="font-bold">{filterTerm}</span> a
                    partir da branch
                    <span class="font-bold">{actualBranch.name}</span></span
                  >
                </Button>
              </div>
            {/snippet}
          </TooltipTrigger>

          <TooltipContent class="inline-block" side="right">
            Criar branch <span class="font-bold">{filterTerm}</span> a partir da
            branch <span class="font-bold">{actualBranch.name}</span>
          </TooltipContent>
        </Tooltip>
      </TooltipProvider>
    {/if}
  </PopoverContent>
</Popover>

<script lang="ts">
  import type { MenuListProps } from './types'

  let { command, items }: MenuListProps = $props()

  let selectedGroupIndex = $state(0)
  let selectedCommandIndex = $state(0)

  let scrollContainer = $state<HTMLElement>(null!)
  let itemRefs = $state<HTMLElement[]>([])

  $effect(() => {
    const flatIndex = getFlatIndex(selectedGroupIndex, selectedCommandIndex)
    const activeItem = itemRefs[flatIndex]

    if (activeItem && scrollContainer) {
      const offsetTop = activeItem.offsetTop
      const offsetHeight = activeItem.offsetHeight

      scrollContainer.scrollTop = offsetTop - offsetHeight / 2
    }
  })

  // Helper to get a flat index from group and command indices
  function getFlatIndex(groupIndex: number, commandIndex: number) {
    return (
      items
        .slice(0, groupIndex)
        .reduce((sum, group) => sum + group.commands.length, 0) + commandIndex
    )
  }

  function selectItem(groupIndex: number, commandIndex: number) {
    const itemCommand = items[groupIndex].commands[commandIndex]
    command(itemCommand)
  }

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === 'ArrowDown' || (event.key === 'n' && event.ctrlKey)) {
      if (!items.length) {
        return false
      }

      const commands = items[selectedGroupIndex].commands

      let newCommandIndex = selectedCommandIndex + 1
      let newGroupIndex = selectedGroupIndex

      if (commands.length - 1 < newCommandIndex) {
        newCommandIndex = 0
        newGroupIndex = selectedGroupIndex + 1
      }

      if (items.length - 1 < newGroupIndex) {
        newGroupIndex = 0
      }

      selectedCommandIndex = newCommandIndex
      selectedGroupIndex = newGroupIndex

      return true
    }

    if (event.key === 'ArrowUp') {
      if (!items.length) {
        return false
      }

      let newCommandIndex = selectedCommandIndex - 1
      let newGroupIndex = selectedGroupIndex

      if (newCommandIndex < 0) {
        newGroupIndex = selectedGroupIndex - 1
        newCommandIndex = items[newGroupIndex]?.commands.length - 1 || 0
      }

      if (newGroupIndex < 0) {
        newGroupIndex = items.length - 1
        newCommandIndex = items[newGroupIndex].commands.length - 1
      }

      selectedCommandIndex = newCommandIndex
      selectedGroupIndex = newGroupIndex

      return true
    }

    if (event.key === 'Enter') {
      if (
        !items.length ||
        selectedGroupIndex === -1 ||
        selectedCommandIndex === -1
      ) {
        return false
      }

      selectItem(selectedGroupIndex, selectedCommandIndex)

      return true
    }

    return false
  }
</script>

<svelte:window onkeydown={handleKeydown} />

{#if items.length}
  <div
    bind:this={scrollContainer}
    class="bg-popover shadow-[1px_1px_4px_rgba(0,0,0,0.1)] rounded-lg max-h-[min(80vh,24rem)] overflow-auto flex-wrap mb-8 p-2"
  >
    <div class="grid grid-cols-1 gap-0.5">
      {#each items as { title, commands }, groupIndex (title)}
        <div
          class="text-muted-foreground font-brand text-xs col-[1/-1] mx-2 mt-4 font-semibold tracking-wide select-none uppercase first:mt-0.5"
        >
          {title}
        </div>

        {#each commands as command, commandIndex (command.label)}
          {@const Icon = command.icon}
          {@const flatIndex = getFlatIndex(groupIndex, commandIndex)}
          <button
            id={`${title}-${command.label}`}
            class="relative flex select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-none transition-colors cursor-pointer data-[disabled]:pointer-events-none data-[disabled]:opacity-50 data-[active=true]:bg-accent data-[active=true]:text-accent-foreground justify-between"
            data-active={selectedGroupIndex === groupIndex &&
              selectedCommandIndex === commandIndex}
            onclick={() => selectItem(groupIndex, commandIndex)}
            bind:this={itemRefs[flatIndex]}
          >
            <div class="flex items-center justify-between gap-2">
              <Icon class="text-muted-foreground size-4 shrink-0" />
              <div
                class="flex text-accent-foreground text-nowrap leading-none flex-col text-left"
              >
                <span class="text-sm font-semibold">{command.label}</span>
                <span class="text-xs text-muted-foreground font-medium"
                  >{command.description}</span
                >
              </div>
            </div>

            <span class="text-xs text-muted-foreground font-brand"
              >{command.shortcut}</span
            >
          </button>
        {/each}
      {/each}
    </div>
  </div>
{/if}

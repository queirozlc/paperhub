<script lang="ts">
  import type { Editor, Range } from '@tiptap/core'
  import type { Command } from './suggestion.svelte'

  type Props = {
    editor: Editor
    range: Range
    items: Command[]
  }

  let { editor, range, items }: Props = $props()
  let selectedIndex = $state(0)
  let elements = $state([])

  $effect(() => {
    if (elements[0] != null) {
      console.log({ element: elements[selectedIndex] })
      elements[selectedIndex]?.scrollIntoView({
        block: 'nearest',
        behavior: 'smooth',
      })
    }
  })

  function handleKeydown(e) {
    if (e.key === 'ArrowUp') {
      e.preventDefault()
      selectedIndex = (selectedIndex + items.length - 1) % items.length
      return true
    }

    if (e.key === 'ArrowDown') {
      e.preventDefault()
      selectedIndex = (selectedIndex + 1) % items.length
      return true
    }

    if (e.key === 'Enter') {
      e.preventDefault()
      const item = items[selectedIndex]

      if (item) {
        item.command({ editor, range })
      }
      return true
    }
  }
</script>

<svelte:window on:keydown={handleKeydown} />

<div
  class="border bg-background-off max-w-full rounded-lg overflow-scroll z-50"
>
  <div class="p-2 text-xs font-medium font-brand text-muted-foreground">
    Blocks
  </div>
  <ul
    class="mt-2 overflow-hidden bg-background-off focus:outline-none no-scrollbar"
    tabindex="-1"
    role="listbox"
    aria-labelledby="slash-command-menu"
    aria-activedescendant="listbox-option-0"
  >
    {#each items as { command, subtitle, title }, i}
      <li>
        <button
          type="button"
          class="text-accent-foreground select-none w-full p-1 text-sm cursor-pointer {i ==
          selectedIndex
            ? 'bg-gray-100'
            : 'bg-white'}"
          id="listbox-option-0"
          onmouseenter={() => (selectedIndex = i)}
          onclick={() => {
            command({ editor, range })
          }}
          bind:this={elements[i]}
        >
          <div class="flex flex-col">
            <div class="flex justify-between">
              <p class="font-normal">{title}</p>
            </div>
            <p class="text-gray-500 mt-2">{subtitle}</p>
          </div>
        </button>
      </li>
    {/each}
  </ul>
</div>

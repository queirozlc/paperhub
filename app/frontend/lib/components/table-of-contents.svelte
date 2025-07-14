<script lang="ts">
  import type { Editor } from '@tiptap/core'
  import * as Sidebar from './ui/sidebar'
  import { TextSelection } from '@tiptap/pm/state'
  import type { TableOfContentsStorage } from '@tiptap/extension-table-of-contents'
  import { cn } from '$lib/utils'

  let { editor }: { editor: Editor } = $props()

  let headings = $derived(
    (editor?.storage.tableOfContents as TableOfContentsStorage).content
  )

  function onItemClick(id: string) {
    if (editor) {
      const element = editor.view.dom.querySelector(`[data-toc-id="${id}"`)
      const pos = editor.view.posAtDOM(element, 0)

      const tr = editor.view.state.tr

      tr.setSelection(new TextSelection(tr.doc.resolve(pos)))

      editor.view.dispatch(tr)

      editor.view.focus()

      if (history.pushState) {
        history.pushState(null, null, `#${id}`)
      }

      window.scrollTo({
        top: element.getBoundingClientRect().top + window.scrollY,
        behavior: 'smooth',
      })
    }
  }

  function onScroll() {
    if (editor) {
      const tr = editor.view.state.tr

      tr.setMeta('scrollIntoView', true)

      editor.view.dispatch(tr)
    }
  }
</script>

<svelte:window onscroll={onScroll} />

{#if headings && headings.length}
  <div class="flex flex-col gap-1.5">
    {#each headings as heading (heading.id)}
      <a
        href={`#${heading.id}`}
        onclick={(e) => {
          e.preventDefault()
          onItemClick(heading.id)
        }}
        style:margin-left={`${1 * heading.level - 1}rem`}
        class={cn(
          'block font-medium text-muted-foreground text-sm px-2 py-1 rounded truncate',
          'hover:text-foreground transition-all',
          {
            'bg-accent text-foreground': heading.isActive,
          }
        )}
      >
        {heading.textContent}
      </a>
    {/each}
  </div>
{:else}
  <Sidebar.GroupLabel>Sem títulos encontrados.</Sidebar.GroupLabel>
{/if}

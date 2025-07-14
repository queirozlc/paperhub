<script lang="ts">
  import { cn } from '$lib/utils'
  import type { NodeViewProps } from '@tiptap/core'
  import type { TableOfContentsStorage } from '@tiptap/extension-table-of-contents'
  import { TextSelection } from '@tiptap/pm/state'
  import { NodeViewWrapper } from 'svelte-tiptap'

  const { editor }: NodeViewProps = $props()

  let headings = $state(editor?.storage.tableOfContents?.content || [])

  editor.on('update', ({ transaction, editor }) => {
    const isNewHeading =
      transaction.doc.content.firstChild?.type.name === 'heading'
    if (isNewHeading) {
      headings = (editor?.storage.tableOfContents as TableOfContentsStorage)
        .content
    }
  })

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
</script>

<NodeViewWrapper>
  <div class="rounded-md flex flex-col">
    {#each headings as heading (heading.id)}
      <a
        href={`#${heading.id}`}
        onclick={(e) => {
          e.preventDefault()
          onItemClick(heading.id)
        }}
        style:margin-left={`${heading.level - 1}rem`}
        data-level={heading.level}
        class={cn(
          'group block text-muted-foreground text-sm py-1 rounded truncate',
          'flex items-center justify-between gap-2',
          'hover:text-foreground transition-all'
        )}
      >
        <span class="truncate shrink-0 group-data-[level=1]:font-bold">
          {heading.textContent}
        </span>
        <span class="border-b-4 border-dotted border-muted-foreground grow"
        ></span>
        <span
          class="text-xs text-muted-foreground group-data-[level=1]:font-bold tabular-nums"
        >
          {heading.level}
        </span>
      </a>
    {/each}
  </div>
</NodeViewWrapper>

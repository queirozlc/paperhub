<script lang="ts">
  import { BubbleMenu, Editor } from 'svelte-tiptap'
  import ToggleTools from './toggle-tools.svelte'
  import { Separator } from './ui/separator'
  import FontFamilyPicker from './font-family-picker.svelte'
  import ContentTypePicker from './content-type-picker.svelte'
  import AiDropdown from './ai-dropdown.svelte'
  import { isCustomNodeSelected, isTextSelected } from '$lib/utils'
  import type { EditorView } from '@tiptap/pm/view'

  let { editor }: { editor: Editor } = $props()

  type ShouldShowProps = {
    view: EditorView
    from: number
  }

  function isMenuAvailable({ view, from }: ShouldShowProps) {
    if (!view || editor.view.dragging) {
      return false
    }

    const domAtPos = view.domAtPos(from || 0).node as HTMLElement
    const nodeDOM = view.nodeDOM(from || 0) as HTMLElement
    const node = nodeDOM || domAtPos

    if (isCustomNodeSelected(editor, node)) {
      return false
    }

    return isTextSelected({ editor })
  }
</script>

<BubbleMenu
  shouldShow={isMenuAvailable}
  class="bg-background border border-input shadow-[1px_1px_4px_rgba(0,0,0,0.1)] p-1 rounded w-fit max-w-[90vw] overflow-hidden"
  tippyOptions={{
    placement: 'top-start',
    popperOptions: {
      modifiers: [
        {
          name: 'preventOverflow',
          options: {
            boundary: 'viewport',
            padding: 8,
          },
        },
        {
          name: 'flip',
          options: {
            fallbackPlacements: ['bottom-start', 'top-end', 'bottom-end'],
          },
        },
      ],
    },
    offset: [0, 8],
    maxWidth: 'calc(100vw - 16px)',
  }}
  {editor}
>
  <div
    class="inline-flex gap-0.5 h-full items-center leading-none text-foreground"
  >
    <AiDropdown {editor} />

    <Separator
      orientation="vertical"
      class="h-full min-h-[1.5rem] w-px mx-1 first:ml-0 last:mr-0"
    />

    <ContentTypePicker {editor} />

    <FontFamilyPicker {editor} />

    <Separator
      orientation="vertical"
      class="h-full min-h-[1.5rem] w-px mx-1 first:ml-0 last:mr-0"
    />

    <ToggleTools {editor} />
  </div>
</BubbleMenu>

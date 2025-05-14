<script lang="ts">
  import type { Editor } from 'svelte-tiptap'
  import type { Readable } from 'svelte/store'

  type FloatingMenuProps = {
    editor: Readable<Editor>
  }

  let { editor }: FloatingMenuProps = $props()
</script>

<div data-test-id="floating-menu"></div>

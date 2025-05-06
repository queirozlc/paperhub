<script lang="ts">
  import EditorLayout from '@/layouts/EditorLayout.svelte'
  import type { DocumentType } from './types'

  let { document }: { document: DocumentType } = $props()
</script>

<EditorLayout {document}>
  <span></span>
</EditorLayout>

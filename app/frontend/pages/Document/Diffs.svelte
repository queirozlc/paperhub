<script lang="ts">
  import DiffsLayout from '$layouts/DiffsLayout.svelte'
  import type { DocumentType } from './types'

  type Props = {
    document: DocumentType
  }

  let { document }: Props = $props()
</script>

<DiffsLayout {document}>
  <div>Diffs</div>
</DiffsLayout>

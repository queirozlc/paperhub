<script lang="ts">
  import DiffsLayout from '$layouts/DiffsLayout.svelte'
  import type { DocumentType, CommitType } from './types'

  type Props = {
    document: DocumentType
    commits: CommitType[]
  }

  let { document, commits }: Props = $props()
</script>

<DiffsLayout {document} {commits}>
  <div>Diffs</div>
</DiffsLayout>

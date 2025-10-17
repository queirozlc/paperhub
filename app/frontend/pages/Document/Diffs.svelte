<script lang="ts">
  import DiffsLayout from '$layouts/DiffsLayout.svelte'
  import type { DocumentType, CommitType } from './types'

  type Props = {
    document: DocumentType
    commits: CommitType[]
    branches: string[]
    current_branch: string
  }

  let { document, branches, commits, current_branch }: Props = $props()
</script>

<DiffsLayout {document} {commits} {branches} {current_branch}>
  <div>Diffs</div>
</DiffsLayout>

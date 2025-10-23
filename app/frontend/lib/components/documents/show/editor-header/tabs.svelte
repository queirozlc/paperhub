<script lang="ts">
  import { Tabs, TabsList, TabsTrigger } from '$lib/components/ui/tabs'
  import { Icon } from '$lib/components/ui/icon'
  import { Link } from '@inertiajs/svelte'
  import type { DocumentType } from '$pages/Document/types'

  type Props = {
    document: DocumentType
  }

  let { document }: Props = $props()

  // if url is /documents/:sqid, activeTab is editor
  // if url is /documents/:sqid/diffs, activeTab is git

  let activeTab = $state(
    window.location.pathname === `/documents/${document.sqid}`
      ? 'editor'
      : 'git'
  )

  // search by ?ref= param to apply into diff url if possible
  let ref = $derived(window.location.search.split('?ref=')[1])

  let diffsUrl = $derived(
    ref
      ? // if there's a ref then it refer's to the branch
        `/documents/${document.sqid}/diffs?ref=${ref}`
      : // if there's no ref then it refer's to main branch
        `/documents/${document.sqid}/diffs`
  )
</script>

<Tabs value={activeTab}>
  <TabsList class="gap-1">
    <Link
      href={`/documents/${document.sqid}`}
      prefetch
      preserveState={false}
      only={['document']}
    >
      <TabsTrigger class="px-2" value="editor">
        <Icon class="size-5" name="file" />
      </TabsTrigger>
    </Link>

    <Link href={diffsUrl} prefetch preserveState={false} only={['document']}>
      <TabsTrigger class="px-2" value="git">
        <Icon class="size-5" name="source-control" />
      </TabsTrigger>
    </Link>
  </TabsList>
</Tabs>

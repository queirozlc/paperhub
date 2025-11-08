<script lang="ts">
  import { Tabs, TabsList, TabsTrigger } from '$lib/components/ui/tabs'
  import { Icon } from '$lib/components/ui/icon'
  import { Link } from '@inertiajs/svelte'
  import type { DocumentType } from '$pages/Document/types'
  import SimpleTooltip from '$lib/components/simple-tooltip.svelte'

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
</script>

<Tabs value={activeTab}>
  <TabsList class="gap-1">
    <SimpleTooltip text="Documento">
      <Link
        href={`/documents/${document.sqid}`}
        prefetch
        replace
        preserveState={false}
        only={['documents']}
      >
        <TabsTrigger class="px-2" value="editor">
          <Icon class="size-5" name="file" />
        </TabsTrigger>
      </Link>
    </SimpleTooltip>

    <SimpleTooltip text="Versionamento (git)">
      <Link
        href={`/documents/${document.sqid}/diffs`}
        prefetch
        replace
        preserveState={false}
        only={['documents', 'file_content']}
      >
        <TabsTrigger class="px-2" value="git">
          <Icon class="size-5" name="source-control" />
        </TabsTrigger>
      </Link>
    </SimpleTooltip>
  </TabsList>
</Tabs>

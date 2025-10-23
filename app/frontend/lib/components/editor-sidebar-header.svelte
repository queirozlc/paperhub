<script lang="ts">
  import Button from '$lib/components/ui/button/button.svelte'
  import { Icon } from '$lib/components/ui/icon'
  import { Separator } from '$lib/components/ui/separator'
  import { Tabs, TabsList, TabsTrigger } from '$lib/components/ui/tabs'
  import {
    Tooltip,
    TooltipContent,
    TooltipProvider,
  } from '$lib/components/ui/tooltip'
  import { DotsHorizontal } from '@voolt_technologies/untitledui-svelte'

  import { SidebarTrigger } from '$lib/components/ui/sidebar'
  import type { DocumentType } from '$pages/Document/types'
  import { Link, page, router } from '@inertiajs/svelte'
  import AvatarStack from './avatar-stack.svelte'

  const user = $page.props.user

  type Props = {
    documentTitleInput?: HTMLHeadingElement
    documentTitle?: string
    document: DocumentType
  }

  let {
    documentTitleInput = $bindable(null),
    documentTitle = $bindable(''),
    document,
  }: Props = $props()

  function updateTitle(target: HTMLHeadingElement) {
    if (!target.textContent) {
      documentTitle = document.title || 'Sem título'
      return
    }

    if (documentTitle !== document.title) {
      router.patch(`/documents/${document.sqid}`, {
        document: { title: documentTitle },
      })
    }
  }

  function handleTitleFocusOut(event: FocusEvent) {
    const target = event.target as HTMLHeadingElement
    updateTitle(target)
  }

  function handleTitleKeydown(event: KeyboardEvent) {
    const target = event.target as HTMLHeadingElement

    if (event.key === 'Enter') {
      event.preventDefault()
      updateTitle(target)
      documentTitleInput.blur()
    }

    if (event.key === 'Escape') {
      event.preventDefault()
      documentTitleInput.blur()
    }
  }
</script>

<header
  class="flex min-h-14 border-sidebar-border border-b items-center px-4 justify-between"
>
  <div class="flex items-center gap-2">
    <div class="flex items-center gap-2">
      <SidebarTrigger for="summary" />
      <Separator class="mr-2 h-4" orientation="vertical" />
    </div>

    <div class="flex items-center gap-2">
      {#if documentTitleInput && documentTitle}
        <h5
          bind:innerText={documentTitle}
          bind:this={documentTitleInput}
          class="font-brand tracking-tight text-accent-foreground max-w-md text-nowrap truncate overflow-x-auto no-scrollbar"
          contenteditable="true"
          onfocusout={handleTitleFocusOut}
          onkeydown={handleTitleKeydown}
        >
          {document.title || 'Sem título'}
        </h5>
      {/if}
      <Tabs value="editor">
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

          <Link
            href={`/documents/${document.sqid}/diffs`}
            prefetch
            preserveState={false}
            only={['document']}
          >
            <TabsTrigger class="px-2" value="git">
              <Icon class="size-5" name="source-control" />
            </TabsTrigger>
          </Link>
        </TabsList>
      </Tabs>
    </div>

    <div class="flex items-center gap-2">
      <Button
        class="text-muted-foreground hover:text-accent-foreground"
        size="icon"
        variant="ghost"
      >
        <Icon class="size-5" name="info-circle" strokeWidth={2} />
      </Button>

      <Button
        class="text-muted-foreground hover:text-accent-foreground"
        size="icon"
        variant="ghost"
      >
        <DotsHorizontal class="size-5" />
      </Button>
    </div>
  </div>

  <div class="flex items-center gap-4">
    <div class="flex items-center gap-2">
      <Separator class="mr-2 h-4" orientation="vertical" />
      <div class="flex items-center gap-1">
        <div class="size-2 rounded-full bg-green-500"></div>
        <span class="font-medium text-muted-foreground text-xs font-brand"
          >Online</span
        >
      </div>

      <TooltipProvider>
        <Tooltip delayDuration={100}>
          <AvatarStack />

          <TooltipContent>
            <span class="pointer-events-none">{user.name}</span>
          </TooltipContent>
        </Tooltip>
      </TooltipProvider>
    </div>

    <div class="flex items-center">
      <Separator class="mr-2 h-4" orientation="vertical" />

      <SidebarTrigger class="-mr-1 ml-auto rotate-180" for="turing" />
    </div>
  </div>
</header>

<script lang="ts">
  import { Separator } from '$lib/components/ui/separator'
  import {
    Tooltip,
    TooltipContent,
    TooltipProvider,
    TooltipTrigger,
  } from '$lib/components/ui/tooltip'

  import { SidebarTrigger } from '$lib/components/ui/sidebar'
  import type { DocumentType } from '$pages/Document/types'
  import { Link, router } from '@inertiajs/svelte'
  import { EditorSidebar } from './documents/show/editor-header'
  import { Button } from './ui/button'
  import { Home02 } from '@voolt_technologies/untitledui-svelte'
  import { getSidebarRegistry } from './ui/sidebar/registry.svelte'

  type Props = {
    documentTitleInput?: HTMLHeadingElement
    documentTitle?: string
    document: DocumentType
    summarySidebarOpen: boolean
    turingSidebarOpen: boolean
  }

  let {
    documentTitleInput = $bindable(null),
    documentTitle = $bindable(''),
    document,
    summarySidebarOpen,
    turingSidebarOpen,
  }: Props = $props()

  function updateTitle(target: HTMLHeadingElement) {
    if (!target.textContent) {
      documentTitle = document.title || 'Sem título'
      return
    }

    if (documentTitle !== document.title) {
      router.patch(
        `/documents/${document.sqid}`,
        {
          document: { title: documentTitle },
        },
        {
          preserveState: true,
          preserveScroll: true,
        }
      )
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

  const turingSidebar = $derived.by(() => {
    const registry = getSidebarRegistry()
    return registry.get('turing')
  })

  const summarySidebar = $derived.by(() => {
    const registry = getSidebarRegistry()
    return registry.get('summary')
  })
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
      <h5
        bind:innerText={documentTitle}
        bind:this={documentTitleInput}
        class="font-brand tracking-tight text-accent-foreground overflow-x-hidden no-scrollbar max-w-xs truncate text-sm"
        contenteditable="true"
        onfocusout={handleTitleFocusOut}
        onkeydown={handleTitleKeydown}
      >
        {document.title || 'Sem título'}
      </h5>
      <EditorSidebar.Tabs {document} />
    </div>

    <Separator class="mr-2 h-4" orientation="vertical" />

    <TooltipProvider>
      <Tooltip delayDuration={100} disableHoverableContent>
        <TooltipTrigger class="sm:inline-flex hidden">
          {#snippet child({ props })}
            <Link href="/documents" {...props}>
              <Button
                variant="ghost"
                size="icon"
                class="text-muted-foreground hover:text-accent-foreground transition-colors"
              >
                <Home02 class="size-5" />
              </Button>
            </Link>
          {/snippet}
        </TooltipTrigger>

        <TooltipContent>
          <span class="pointer-events-none">Voltar para a página inicial</span>
        </TooltipContent>
      </Tooltip>
    </TooltipProvider>
  </div>

  <div class="flex items-center gap-4">
    <EditorSidebar.OnlineIndicator />

    <div class="flex items-center">
      <Separator class="mr-2 h-4 hidden sm:block" orientation="vertical" />

      <SidebarTrigger class="-mr-1 ml-auto rotate-180" for="turing" />
    </div>
  </div>
</header>

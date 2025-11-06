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
  import { Link, page, router } from '@inertiajs/svelte'
  import AvatarStack from './avatar-stack.svelte'
  import { EditorSidebar } from './documents/show/editor-header'
  import { Button } from './ui/button'
  import { Home05 } from '@voolt_technologies/untitledui-svelte'

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
        class="font-brand tracking-tight text-accent-foreground overflow-x-hidden no-scrollbar max-w-xs truncate"
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
        <TooltipTrigger>
          {#snippet child({ props })}
            <Link href="/documents" {...props}>
              <Button
                variant="ghost"
                size="icon"
                class="text-muted-foreground hover:text-accent-foreground transition-colors"
              >
                <Home05 class="size-5" />
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

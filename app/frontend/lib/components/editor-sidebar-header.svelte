<script lang="ts">
  import Button from '$lib/components/ui/button/button.svelte'
  import { Icon } from '$lib/components/ui/icon'
  import { Separator } from '$lib/components/ui/separator'
  import * as Tabs from '$lib/components/ui/tabs'
  import * as Tooltip from '$lib/components/ui/tooltip'
  import type { UserType } from '$pages/Users/types'
  import {
    DotsHorizontal,
    Share01,
  } from '@voolt_technologies/untitledui-svelte'

  import * as Sidebar from '$lib/components/ui/sidebar'
  import type { DocumentType } from '$pages/Document/types'
  import { page, router } from '@inertiajs/svelte'
  import AvatarStack from './avatar-stack.svelte'

  const user = $page.props.user as UserType

  type Props = {
    documentTitleInput: HTMLHeadingElement
    documentTitle: string
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
      // unfocus input
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
  <div class="flex items-center gap-4">
    <div class="flex items-center gap-2">
      <Sidebar.Trigger for="summary" />
      <Separator orientation="vertical" class="mr-2 h-4" />
    </div>

    <div class="flex items-center gap-4">
      <h5
        bind:this={documentTitleInput}
        contenteditable="true"
        bind:innerText={documentTitle}
        onfocusout={handleTitleFocusOut}
        onkeydown={handleTitleKeydown}
        class="font-brand tracking-tight text-accent-foreground max-w-md text-nowrap truncate overflow-x-auto no-scrollbar"
      >
        {document.title || 'Sem título'}
      </h5>
      <Tabs.Root value="editor">
        <Tabs.List class="gap-1">
          <Tabs.Trigger value="editor" class="px-2" preserveState>
            <Icon name="file" class="size-5" />
          </Tabs.Trigger>

          <Tabs.Trigger value="git" class="px-2" preserveState>
            <Icon name="source-control" class="size-5" />
          </Tabs.Trigger>
        </Tabs.List>
      </Tabs.Root>
    </div>

    <div class="flex items-center gap-2">
      <Button
        variant="ghost"
        size="icon"
        class="text-muted-foreground hover:text-accent-foreground"
      >
        <Icon name="info-circle" strokeWidth={2} class="size-5" />
      </Button>

      <Button
        variant="ghost"
        size="icon"
        class="text-muted-foreground hover:text-accent-foreground"
      >
        <DotsHorizontal class="size-5" />
      </Button>
    </div>
  </div>

  <div class="flex items-center gap-4">
    <Button variant="outline" size="sm" class="shadow-none h-7">
      <Share01 />
      <span class="font-medium">Compartilhar</span>
    </Button>

    <div class="flex items-center gap-2">
      <Separator orientation="vertical" class="mr-2 h-4" />
      <div class="flex items-center gap-1">
        <div class="size-2 rounded-full bg-green-500"></div>
        <span class="font-medium text-muted-foreground text-xs font-brand"
          >Online</span
        >
      </div>

      <Tooltip.Provider>
        <Tooltip.Root delayDuration={100}>
          <AvatarStack />

          <Tooltip.Content>
            <span class="pointer-events-none">{user.name}</span>
          </Tooltip.Content>
        </Tooltip.Root>
      </Tooltip.Provider>
    </div>

    <div class="flex items-center">
      <Separator orientation="vertical" class="mr-2 h-4" />

      <Sidebar.Trigger class="-mr-1 ml-auto rotate-180" for="turing" />
    </div>
  </div>
</header>

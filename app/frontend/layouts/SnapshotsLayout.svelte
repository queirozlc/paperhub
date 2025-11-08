<script lang="ts">
  import type { Snippet } from 'svelte'
  import {
    SidebarProvider,
    Sidebar,
    SidebarHeader,
    SidebarContent,
    SidebarGroup,
    SidebarInset,
    SidebarFooter,
    SidebarMenuItem,
  } from '$lib/components/ui/sidebar'
  import type { DocumentType } from '$pages/Document/types'
  import { EditorSidebar } from '$lib/components/documents/show/editor-header'
  import { Camera, type Icon } from '@lucide/svelte'
  import {
    Tabs,
    TabsContent,
    TabsList,
    TabsTrigger,
  } from '$lib/components/ui/tabs'
  import SidebarMenu from '$lib/components/ui/sidebar/sidebar-menu.svelte'
  import { page } from '@inertiajs/svelte'
  import Avatar from '$lib/components/ui/avatar/avatar.svelte'
  import { AvatarFallback, AvatarImage } from '$lib/components/ui/avatar'
  import { userNameFallback } from '$lib/utils'
  import { Input } from '$lib/components/ui/input'
  import Label from '$lib/components/ui/label/label.svelte'
  import { Textarea } from '$lib/components/ui/textarea'
  import Button from '$lib/components/ui/button/button.svelte'
  import { toast } from 'svelte-sonner'
  import type { Editor } from 'svelte-tiptap'
  import * as Y from 'yjs'

  type Props = {
    children: Snippet
    document: DocumentType
    editor: Editor
    ydoc: Y.Doc
  }

  export type TabItem = {
    icon: typeof Icon
    value: string
    label: string
  }

  let { children, document, editor, ydoc }: Props = $props()

  const tabs: TabItem[] = [
    {
      icon: Camera,
      value: 'snapshots',
      label: 'Snapshots',
    },
  ]

  let activeTab = $state<'snapshots'>('snapshots')
  let message = $state('')
  let description = $state('')
  let isCreating = $state(false)
  let form = $state<HTMLFormElement | null>(null)

  const user = $page.props.user

  async function createSnapshot(e: SubmitEvent) {
    e.preventDefault()

    if (!form?.checkValidity()) {
      toast.error('Message is required')
      return
    }

    isCreating = true
    try {
      editor.commands.addVersion({
        message,
        description,
        date: new Date().getTime(),
        clientID: ydoc.clientID,
        author: {
          id: user.id,
          name: user.name,
          email: user.email,
          avatar: user.avatar,
        },
      })
      isCreating = false
      form?.reset()
      toast.success('Snapshot created successfully')
    } catch (error) {
      console.error('Failed to create snapshot:', error)
      toast.error('Failed to create snapshot')
    } finally {
      isCreating = false
    }
  }
</script>

<div class="overflow-hidden flex w-full">
  <SidebarProvider
    open={true}
    name="snapshot-panel"
    style="--sidebar-width: 20rem;"
    class="w-fit overflow-hidden max-h-dvh"
  >
    <Sidebar transparent>
      <Tabs bind:value={activeTab} class="w-full h-full">
        <SidebarHeader class="p-0 h-14 justify-end">
          <TabsList
            class="before:bg-border relative h-auto w-full gap-0.5 bg-transparent p-0 before:absolute before:inset-x-0 before:bottom-0 before:h-px px-1"
          >
            {#each tabs as tab (tab.value)}
              {@const Icon = tab.icon}
              <TabsTrigger
                value={tab.value}
                class="bg-accent overflow-hidden rounded-b-none border py-2 data-[state=active]:z-10 data-[state=active]:shadow-none w-full"
              >
                <Icon
                  class="-ms-0.5 me-1.5 opacity-60"
                  size={16}
                  aria-hidden="true"
                />
                {tab.label}
              </TabsTrigger>
            {/each}
          </TabsList>
        </SidebarHeader>

        <SidebarContent>
          <SidebarGroup class="space-y-2">
            <TabsContent value="snapshots">
              <div class="p-4">
                <h3 class="text-sm font-semibold mb-2">Create Snapshot</h3>
                <p class="text-xs text-muted-foreground mb-4">
                  Save the current state of your document
                </p>
              </div>
            </TabsContent>
          </SidebarGroup>
        </SidebarContent>
      </Tabs>

      <SidebarFooter>
        <SidebarMenu>
          <SidebarMenuItem class="gap-4 flex flex-col">
            <form
              bind:this={form}
              class="flex flex-col w-full gap-2"
              onsubmit={createSnapshot}
            >
              <div class="flex items-center gap-2">
                <Avatar class="size-9">
                  <AvatarImage
                    src={user.avatar}
                    class="object-cover block"
                    alt={user.name}
                  />
                  <AvatarFallback>
                    {userNameFallback(user.name)}
                  </AvatarFallback>
                </Avatar>

                <div class="flex flex-col gap-1 grow">
                  <Label for="snapshot-message" class="text-sm font-medium"
                    >Snapshot message</Label
                  >
                  <Input
                    bind:value={message}
                    id="snapshot-message"
                    name="snapshot-message"
                    class="text-sm shadow h-9"
                    placeholder="Ex: 'Version 1.0'"
                    disabled={isCreating}
                  />
                </div>
              </div>

              <div class="relative">
                <Textarea
                  bind:value={description}
                  placeholder="Add description (optional)"
                  class="resize-none pb-10 no-scrollbar"
                  disabled={isCreating}
                />
              </div>

              <Button type="submit" class="w-full" disabled={isCreating}>
                {isCreating ? 'Creating...' : 'Create Snapshot'}
              </Button>
            </form>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarFooter>
    </Sidebar>
  </SidebarProvider>

  <SidebarInset class="w-full">
    <EditorSidebar.Header>
      <EditorSidebar.Trigger for="snapshot-panel" />
      <EditorSidebar.Tabs {document} />
    </EditorSidebar.Header>

    <div class="flex overflow-y-scroll py-4">
      <div class="flex flex-1 flex-col gap-4 scrollbar-hidden">
        {@render children()}
      </div>
    </div>
  </SidebarInset>
</div>

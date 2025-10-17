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
  import type { DocumentType, CommitType } from '$pages/Document/types'
  import { EditorSidebar } from '$lib/components/documents/show/editor-header'

  import { Separator } from '$lib/components/ui/separator'

  import { GitCommitVertical, History, type Icon } from '@lucide/svelte'
  import {
    Tabs,
    TabsContent,
    TabsList,
    TabsTrigger,
  } from '$lib/components/ui/tabs'
  import { Changes, Commits } from '$lib/components/diffs'
  import SidebarMenu from '$lib/components/ui/sidebar/sidebar-menu.svelte'
  import { page, router, useForm } from '@inertiajs/svelte'
  import Avatar from '$lib/components/ui/avatar/avatar.svelte'
  import { AvatarFallback, AvatarImage } from '$lib/components/ui/avatar'
  import { userNameFallback } from '$lib/utils'
  import { Input } from '$lib/components/ui/input'
  import Label from '$lib/components/ui/label/label.svelte'
  import { Textarea } from '$lib/components/ui/textarea'
  import Button from '$lib/components/ui/button/button.svelte'

  type Props = {
    children: Snippet
    document: DocumentType
    branches: string[]
    current_branch: string
    commits: CommitType[]
  }

  export type TabItem = {
    icon: typeof Icon
    value: string
    label: string
  }

  export type CommitForm = {
    message: string
    description?: string
  }

  let { children, document, branches, current_branch, commits }: Props =
    $props()

  const tabs: TabItem[] = [
    {
      icon: GitCommitVertical,
      value: 'changes',
      label: 'Alterações',
    },
    {
      icon: History,
      label: 'Histórico',
      value: 'history',
    },
  ]

  let form = useForm<CommitForm>({
    message: '',
    description: '',
  })

  let activeTab = $state<'changes' | 'history'>('changes')

  const user = $page.props.user

  function createBranch(name: string, target: string) {
    router.post(
      `/documents/${document.sqid}/branches`,
      {
        branch: { name, target },
      },
      {
        only: ['branches', 'current_branch'],
      }
    )
  }

  function commitChanges(e: SubmitEvent) {
    e.preventDefault()
    $form
      .transform((data) => ({ commit: { ...data } }))
      .post(`/documents/${document.sqid}/commits`, {
        preserveUrl: true,
      })
    $form.reset()
  }
</script>

<div class="overflow-hidden flex w-full">
  <SidebarProvider
    open={true}
    name="git-panel"
    style="--sidebar-width: 20rem;"
    class="w-fit overflow-hidden max-h-dvh"
  >
    <Sidebar transparent>
      <Tabs
        bind:value={activeTab}
        class="w-full h-full"
        onValueChange={(tab) => {
          if (tab === 'history' && !commits) {
            router.reload({
              only: ['commits'],
            })
          }
        }}
      >
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
            <TabsContent value="changes">
              <Changes />
            </TabsContent>
            <TabsContent value="history">
              <Commits {commits} />
            </TabsContent>
          </SidebarGroup>
        </SidebarContent>
      </Tabs>

      {#if activeTab === 'changes'}
        <SidebarFooter>
          <SidebarMenu>
            <SidebarMenuItem class="gap-4 flex flex-col">
              <form class="flex flex-col w-full gap-2" onsubmit={commitChanges}>
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
                    <Label for="commit-message" class="text-sm font-medium"
                      >Adicione um comentário</Label
                    >
                    <Input
                      bind:value={$form.message}
                      id="commit-message"
                      name="commit-message"
                      class="text-sm shadow h-9"
                      placeholder="Ex: 'Novo parágrafo adicionado'"
                    />
                  </div>
                </div>

                <div class="relative">
                  <Textarea
                    bind:value={$form.description}
                    placeholder="Caso necessário, adicione alguns detalhes (opcional)"
                    class="resize-none pb-10 no-scrollbar"
                  />
                </div>

                <Button type="submit" class="w-full">Salvar alterações</Button>
              </form>
            </SidebarMenuItem>
          </SidebarMenu>
        </SidebarFooter>
      {/if}
    </Sidebar>
  </SidebarProvider>

  <SidebarInset class="w-full">
    <EditorSidebar.Header>
      <EditorSidebar.Trigger for="git-panel" />
      <EditorSidebar.Tabs {document} />
      <div class="flex items-center gap-2">
        <Separator class="h-4" orientation="vertical" />
        <EditorSidebar.BranchSelect
          document_id={document.sqid}
          {current_branch}
          {branches}
          {createBranch}
        />
      </div>
    </EditorSidebar.Header>

    <div class="flex overflow-y-scroll py-4">
      <div class="flex flex-1 flex-col gap-4 scrollbar-hidden">
        {@render children()}
      </div>
    </div>
  </SidebarInset>
</div>

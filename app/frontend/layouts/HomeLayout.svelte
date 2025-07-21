<script lang="ts" module>
  import { Blocks, MessageCircleQuestion, Settings, Sparkles } from '@lucide/svelte'

  import { FilterLines, Home05 as Home, Inbox01 as Inbox } from '@voolt_technologies/untitledui-svelte'

  import type { InvitationForm } from '$pages/Document/types'

  const data = {
    navMain: [
      {
        title: 'Pergunte ao Turing ✨',
        url: '#',
        icon: Sparkles,
        tooltip:
          'Faça perguntas sobre seus documentos e receba respostas instantâneas',
      },
      {
        title: 'Página inicial',
        url: '#',
        icon: Home,
        isActive: true,
        tooltip: 'Volte para a página inicial',
      },
      {
        title: 'Inbox',
        url: '#',
        icon: Inbox,
        badge: 10,
        tooltip:
          'Acesse sua caixa de entrada para ver as atualizações mais recentes',
      },
    ],
    navSecondary: [
      {
        title: 'Configurações',
        url: '#',
        icon: Settings,
      },
      {
        title: 'Modelos',
        url: '#',
        icon: Blocks,
      },
      {
        title: 'Ajuda',
        url: '#',
        icon: MessageCircleQuestion,
      },
    ],
    folders: [],
  }

  export { default as layout } from './HomeLayout.svelte'
</script>

<script lang="ts">
  import { Sidebar, SidebarInset, SidebarHeader, SidebarProvider, SidebarTrigger, SidebarContent, SidebarGroup } from
            '$lib/components/ui/sidebar'

  import NavFolders from '$lib/components/nav-folders.svelte'
  import NavMain from '$lib/components/nav-main.svelte'
  import NavSecondary from '$lib/components/nav-secondary.svelte'
  import TeamSwitcher from '$lib/components/team-switcher.svelte'
  import {
    Avatar,
    AvatarFallback,
    AvatarImage,
  } from '$lib/components/ui/avatar'
  import Button from '$lib/components/ui/button/button.svelte'
  import Separator from '$lib/components/ui/separator/separator.svelte'
  import { Tabs, TabsList, TabsTrigger } from '$lib/components/ui/tabs'
  import type { TeamType } from '$pages/Team/types'
  import { Send } from '@lucide/svelte'
  import type { Snippet } from 'svelte'
  import { useForm } from '@inertiajs/svelte'
  import InvitationDialog from '$lib/components/documents/invitation-dialog.svelte'
  import { toast } from 'svelte-sonner'
  type Props = {
    teams: TeamType[]
    children: Snippet
  }

  let { teams, children }: Props = $props()

  let openInvitationDialog = $state(false)

  const form = useForm<InvitationForm>({
    email: '',
    role: '',
  })

  function sendInvite(e: SubmitEvent) {
    e.preventDefault()
    $form
      .transform(({ email, role }) => ({
        user: { email, invitation_role: role },
      }))
      .post('/invitation', {
        preserveState: false,
        onSuccess: () => {
          openInvitationDialog = false
          toast.success('Convite enviado com sucesso')
        },
      })
  }
</script>

<svelte:head>
  <title>Home | Seus Documentos</title>
  <meta
    content="Seus Documentos - Dashboard de gerenciamento de documentos"
    name="description"
  />
</svelte:head>

<SidebarProvider>
  <Sidebar>
    <SidebarHeader>
      <TeamSwitcher {teams} />
      <NavMain items={data.navMain} />
    </SidebarHeader>
    <SidebarContent>
      <NavFolders folders={data.folders} />
      <NavSecondary class="mt-auto" items={data.navSecondary} />
      <SidebarGroup class="pb-4">
        <InvitationDialog
          bind:form={$form}
          bind:open={openInvitationDialog}
          {sendInvite}
        />
      </SidebarGroup>
    </SidebarContent>
  </Sidebar>

  <SidebarInset>
    <header class="flex h-14 items-center px-4 justify-between">
      <div class="flex items-center gap-2">
        <SidebarTrigger />
        <Separator class="mr-2 h-4" orientation="vertical" />
        <Button class="gap-2 h-7 shadow-none" size="sm" variant="outline">
          <div class="rounded-full border border-accent-foreground p-0.5">
            <FilterLines class="size-2 text-accent-foreground" />
          </div>
          <span class="text-accent-foreground/80 font-medium">Filtrar</span>
        </Button>
      </div>
      <div>
        <Tabs value="documents">
          <TabsList>
            <TabsTrigger value="documents">Documentos</TabsTrigger>
            <TabsTrigger value="folders">Pastas</TabsTrigger>
          </TabsList>
        </Tabs>
      </div>
      <div class="flex items-center gap-5">
        <Avatar class="size-8">
          <AvatarImage alt="@shadcn" src="https://github.com/shadcn.png" />
          <AvatarFallback>CN</AvatarFallback>
        </Avatar>

        <Button
          class="font-brand font-semibold rounded-lg px-6"
          onclick={() => (openInvitationDialog = true)}
          size="sm"
        >
          <Send />
          Convidar
        </Button>
      </div>
    </header>
    <div class="flex flex-1 relative flex-col gap-2 py-10">
      {@render children()}
    </div>
  </SidebarInset>
</SidebarProvider>

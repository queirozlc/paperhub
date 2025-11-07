<script lang="ts" module>
  import { Icon, Settings } from '@lucide/svelte'

  import { Home05 as Home } from '@voolt_technologies/untitledui-svelte'

  import type { InvitationForm } from '$pages/Document/types'

  export type NavMainItem = {
    title: string
    url: string
    // Eslint disabled because we need to use any to pass the icon to the component
    // the lib untitledui-svelte is not typed yet
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    icon: any
    isActive?: boolean
    tooltip: string
    badge?: number
  }

  export type NavSecondaryItem = {
    name: string
    title: string
    url?: string
    icon: typeof Icon
    badge?: string
  }

  export { default as layout } from './HomeLayout.svelte'
</script>

<script lang="ts">
  import {
    Sidebar,
    SidebarInset,
    SidebarHeader,
    SidebarProvider,
    SidebarTrigger,
    SidebarContent,
    SidebarGroup,
  } from '$lib/components/ui/sidebar'

  import { NavMain, NavSecondary } from '$lib/components/documents/index'
  import TeamSwitcher from '$lib/components/team-switcher.svelte'
  import {
    Avatar,
    AvatarFallback,
    AvatarImage,
  } from '$lib/components/ui/avatar'
  import Button from '$lib/components/ui/button/button.svelte'
  import Separator from '$lib/components/ui/separator/separator.svelte'
  import type { TeamType } from '$pages/Team/types'
  import { Send } from '@lucide/svelte'
  import type { Snippet } from 'svelte'
  import { useForm } from '@inertiajs/svelte'
  import { InvitationDialog } from '$lib/components/documents/index'
  import { toast } from 'svelte-sonner'
  import { page } from '@inertiajs/svelte'
  import type { UserInvitationType } from '$pages/Users/types'

  type Props = {
    teams: TeamType[]
    children: Snippet
    user_invitations: UserInvitationType[]
    team_members: UserInvitationType[]
    active_team: TeamType
  }

  const sidebarSections: {
    navMain: NavMainItem[]
    navSecondary: NavSecondaryItem[]
  } = {
    navMain: [
      // {
      //   title: 'Pergunte ao Turing ✨',
      //   url: '#',
      //   icon: Sparkles,
      //   tooltip:
      //     'Faça perguntas sobre seus documentos e receba respostas instantâneas',
      // },
      {
        title: 'Página inicial',
        url: '#',
        icon: Home,
        isActive: true,
        tooltip: 'Volte para a página inicial',
      },
      // {
      //   title: 'Inbox',
      //   url: '#',
      //   icon: Inbox,
      //   badge: 10,
      //   tooltip:
      //     'Acesse sua caixa de entrada para ver as atualizações mais recentes',
      // },
    ],
    navSecondary: [
      {
        name: 'settings',
        title: 'Configurações',
        icon: Settings,
      },
      // {
      //   name: 'templates',
      //   title: 'Modelos',
      //   url: '#',
      //   icon: Blocks,
      // },
      // {
      //   name: 'help',
      //   title: 'Ajuda',
      //   url: '#',
      //   icon: MessageCircleQuestion,
      // },
    ],
  }

  let { teams, children, user_invitations, team_members, active_team }: Props =
    $props()

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
      .post('/users/invitation', {
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
      <TeamSwitcher {teams} {active_team} />
      <NavMain items={sidebarSections.navMain} />
    </SidebarHeader>
    <SidebarContent>
      <!-- <NavFolders folders={sidebarSections.folders} /> -->
      <NavSecondary
        class="mt-auto"
        items={sidebarSections.navSecondary}
        {active_team}
        {user_invitations}
        {team_members}
      />
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
        <!-- <Button class="gap-2 h-7 shadow-none" size="sm" variant="outline">
          <div class="rounded-full border border-accent-foreground p-0.5">
            <FilterLines class="size-2 text-accent-foreground" />
          </div>
          <span class="text-accent-foreground/80 font-medium">Filtrar</span>
        </Button> -->
      </div>
      <!-- <div>
        <Tabs value="documents">
          <TabsList>
            <TabsTrigger value="documents">Documentos</TabsTrigger>
            <TabsTrigger value="folders">Pastas</TabsTrigger>
          </TabsList>
        </Tabs>
      </div> -->
      <div class="flex items-center gap-5">
        <Avatar class="size-8">
          <AvatarImage
            alt={$page.props.user.name}
            src={$page.props.user.avatar}
          />
          <AvatarFallback>
            {$page.props.user.name.slice(0, 2).toUpperCase()}
          </AvatarFallback>
        </Avatar>

        <Button
          class="font-brand hidden font-semibold rounded-lg px-6 sm:inline-flex"
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

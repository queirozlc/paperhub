<script lang="ts">
  import { Button } from '$lib/components/ui/button'
  import {
    SettingsDialogContent,
    SettingsDialogDescription,
    SettingsDialogGroup,
    SettingsDialogHeader,
    SettingsDialogTitle,
  } from '$lib/components/ui/settings-dialog'
  import { Tabs, TabsList, TabsTrigger } from '$lib/components/ui/tabs'

  import { AvatarFallback } from '$lib/components/ui/avatar'
  import AvatarImage from '$lib/components/ui/avatar/avatar-image.svelte'
  import Avatar from '$lib/components/ui/avatar/avatar.svelte'
  import { Dialog, DialogTrigger } from '$lib/components/ui/dialog'
  import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
  } from '$lib/components/ui/table'
  import { userNameFallback } from '$lib/utils'
  import type { InvitationForm } from '$pages/Document/types'
  import type { TeamType } from '$pages/Team/types'
  import { TeamRole, type UserInvitationType } from '$pages/Users/types'
  import { page, router, useForm } from '@inertiajs/svelte'
  import { Send, Trash } from '@lucide/svelte'
  import { formatDate } from 'date-fns/format'
  import { onMount } from 'svelte'
  import { toast } from 'svelte-sonner'
  import { InvitationDialogContent } from '../invitation-dialog'

  type Props = {
    user_invitations: UserInvitationType[]
    active_team: TeamType
    team_members: UserInvitationType[]
  }

  const user = $page.props.user

  const invitationColumns = [
    { id: 'name', label: 'Nome' },
    { id: 'invitation_sent_at', label: 'Convidado em' },
    { id: 'actions', label: 'Ações' },
  ]

  const memberColumns = [
    { id: 'name', label: 'Nome' },
    { id: 'role', label: 'Cargo' },
    { id: 'actions', label: 'Ações' },
  ]

  const form = useForm<InvitationForm>({
    email: '',
    role: '',
  })

  let currentTab = $state('invitations')
  let openInvitationDialog = $state(false)
  let { user_invitations, team_members, active_team }: Props = $props()
  const showRole = (role: TeamRole) => {
    if (role === TeamRole.OWNER) {
      return 'Administrador'
    }

    return 'Membro'
  }

  function revokeInvitation(email: string) {
    router.get(
      `/users/invitation/remove?email=${email}`,
      {},
      {
        preserveState: true,
        preserveScroll: true,
        only: ['user_invitations', 'team_members'],
      }
    )
  }

  function sendInvite(e: SubmitEvent) {
    e.preventDefault()
    $form
      .transform(({ email, role }) => ({
        user: { email, invitation_role: role },
      }))
      .post('/users/invitation', {
        only: ['user_invitations', 'team_members'],
        onSuccess: () => {
          openInvitationDialog = false
          $form.reset()
          toast.success('Convite enviado com sucesso')
        },
      })
  }

  function removeMember(id: number) {
    router.delete(`/teams/members/${id}`, {
      only: ['team_members', 'active_team'],
    })
  }

  onMount(() => {
    router.reload({
      only: ['user_invitations', 'team_members'],
    })
  })
</script>

<SettingsDialogContent>
  <SettingsDialogGroup>
    <SettingsDialogHeader>
      <SettingsDialogTitle>Configurações de Membros</SettingsDialogTitle>
      <SettingsDialogDescription>
        Gerencie os membros do time
      </SettingsDialogDescription>
    </SettingsDialogHeader>

    <div class="space-y-5">
      <div class="flex items-center justify-between">
        <Tabs bind:value={currentTab}>
          <TabsList class="w-full">
            <TabsTrigger value="invitations">Convites</TabsTrigger>
            <TabsTrigger value="members">Membros</TabsTrigger>
          </TabsList>
        </Tabs>

        <Dialog bind:open={openInvitationDialog}>
          <DialogTrigger>
            {#snippet child({ props })}
              <Button size="sm" class="font-brand font-semibold h-7" {...props}>
                <Send class="size-4" />
                Convidar Membro
              </Button>
            {/snippet}
          </DialogTrigger>

          <InvitationDialogContent bind:form={$form} onSubmit={sendInvite} />
        </Dialog>
      </div>

      {#if currentTab === 'invitations'}
        <Table>
          <TableHeader>
            <TableRow>
              {#each invitationColumns as col (col.id)}
                <TableHead class="text-left">{col.label}</TableHead>
              {/each}
            </TableRow>
          </TableHeader>

          <TableBody>
            {#each user_invitations as { avatar, email, name, invitation_sent_at, id } (id)}
              <TableRow>
                <TableCell>
                  <div class="flex items-center gap-3">
                    <Avatar>
                      <AvatarImage src={avatar} />
                      <AvatarFallback>
                        {userNameFallback(name)}
                      </AvatarFallback>
                    </Avatar>
                    <div class="max-w-[150px] truncate text-muted-foreground">
                      <p class="font-semibold text-foreground truncate">
                        {name}
                      </p>
                      <span class="text-muted-foreground mt-0.5 text-xs">
                        {email}
                      </span>
                    </div>
                  </div>
                </TableCell>
                <TableCell
                  >{formatDate(invitation_sent_at, 'dd/MM/yyyy')}</TableCell
                >
                <TableCell>
                  <Button
                    size="icon"
                    variant="ghost"
                    class="group hover:bg-destructive/10"
                    onclick={() => revokeInvitation(email)}
                  >
                    <Trash
                      class="size-4 text-destructive group-hover:text-destructive/80"
                    />
                  </Button>
                </TableCell>
              </TableRow>
            {/each}
          </TableBody>
        </Table>
      {/if}

      {#if currentTab === 'members'}
        <Table>
          <TableHeader>
            <TableRow>
              {#each memberColumns as col (col.id)}
                <TableHead>{col.label}</TableHead>
              {/each}
            </TableRow>
          </TableHeader>

          <TableBody>
            {#each [user, ...team_members] as { avatar, email, name, role, id } (id)}
              <TableRow>
                <TableCell>
                  <div class="flex items-center gap-3">
                    <Avatar>
                      <AvatarImage src={avatar} />
                      <AvatarFallback>
                        {userNameFallback(name)}
                      </AvatarFallback>
                    </Avatar>
                    <div class="max-w-[150px] truncate text-muted-foreground">
                      <div class="font-semibold text-foreground truncate">
                        {name}
                        {#if id === user.id}
                          <span class="text-xs text-muted-foreground">
                            (Você)
                          </span>
                        {/if}
                      </div>
                      <span class="text-muted-foreground mt-0.5 text-xs">
                        {email}
                      </span>
                    </div>
                  </div>
                </TableCell>
                <TableCell>{showRole(role)}</TableCell>
                <TableCell>
                  <Button
                    size="icon"
                    variant="ghost"
                    class="group hover:bg-destructive/10"
                    onclick={() => removeMember(id)}
                    disabled={id === user.id || active_team.owner_id === id}
                  >
                    <Trash
                      class="size-4 text-destructive group-hover:text-destructive/80"
                    />
                  </Button>
                </TableCell>
              </TableRow>
            {/each}
          </TableBody>
        </Table>
      {/if}
    </div>
  </SettingsDialogGroup>
</SettingsDialogContent>

<script lang="ts">
  import {
    SettingsDialogContent,
    SettingsDialogDescription,
    SettingsDialogGroup,
    SettingsDialogHeader,
    SettingsDialogTitle,
  } from '$lib/components/ui/settings-dialog'
  import type { TeamType } from '$pages/Team/types'
  import { page, router, useForm } from '@inertiajs/svelte'
  import AvatarInput from '$lib/components/avatar-input.svelte'
  import Input from '$lib/components/ui/input/input.svelte'
  import Label from '$lib/components/ui/label/label.svelte'
  import {
    AlertDialog,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogRemove,
    AlertDialogTitle,
    AlertDialogTrigger,
  } from '$lib/components/ui/alert-dialog'
  import { ChevronRight } from '@lucide/svelte'
  import { TeamRole } from '$pages/Users/types'

  type Props = {
    active_team: TeamType
  }

  const user = $page.props.user

  let { active_team }: Props = $props()

  let formRef: HTMLFormElement | null = $state(null)
  let nameInput: HTMLInputElement | null = $state(null)

  const form = useForm<{ name: string; cover: File }>({
    cover: null,
    name: active_team.name,
  })

  function submit(e: SubmitEvent) {
    e.preventDefault()
    nameInput?.blur()
    $form
      .transform(({ cover, name }) => ({
        team: {
          name,
          cover,
        },
      }))
      .patch(`/teams/${active_team.id}`)
  }

  function destroyTeam() {
    router.delete(`/teams/${active_team.id}`, {
      preserveState: false,
    })
  }
</script>

<SettingsDialogContent>
  <SettingsDialogGroup>
    <SettingsDialogHeader>
      <SettingsDialogTitle
        >Preferências do Time {active_team.name}</SettingsDialogTitle
      >
      <SettingsDialogDescription>
        Configure as preferências do seu time
      </SettingsDialogDescription>
    </SettingsDialogHeader>

    <div>
      <h5 class="text-sm font-brand font-medium">Informações do Time</h5>
      <p class="text-xs py-2 font-medium text-muted-foreground font-brand">
        Altere a imagem e o nome do time
      </p>

      <form
        bind:this={formRef}
        class="flex items-center gap-4 mt-4"
        onsubmit={submit}
      >
        <AvatarInput
          bind:selectedImage={$form.cover}
          initialImage={active_team.cover}
          onFileChange={() => {
            if (formRef) {
              formRef.requestSubmit()
            }
          }}
          size="sm"
        />
        <div class="flex flex-col gap-2">
          <Label class="text-xs font-medium text-muted-foreground" for="name">
            Nome do Time
          </Label>
          <Input
            bind:ref={nameInput}
            bind:value={$form.name}
            id="name"
            onfocusout={() => {
              if (formRef) {
                formRef.requestSubmit()
              }
            }}
          />
        </div>
      </form>
    </div>
  </SettingsDialogGroup>

  {#if user.role === TeamRole.OWNER}
    <SettingsDialogGroup>
      <SettingsDialogTitle>Suporte</SettingsDialogTitle>

      <AlertDialog>
        <AlertDialogTrigger>
          {#snippet child({ props })}
            <div
              class="items-center flex justify-between cursor-pointer"
              {...props}
            >
              <div class="flex flex-col gap-1">
                <p class="text-sm font-brand font-medium text-destructive">
                  Remover Time
                </p>
                <p class="text-xs font-medium text-muted-foreground font-brand">
                  Remova o time permanentemente.
                </p>
              </div>

              <ChevronRight class="size-4 text-muted-foreground" />
            </div>
          {/snippet}
        </AlertDialogTrigger>

        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Remover Time</AlertDialogTitle>
            <AlertDialogDescription class="flex flex-col gap-2">
              <p>
                Você está prestes a remover o time permanentemente, isso irá
                excluir o time para você e todos os membros, e excluir todos os
                dados (documentos, pastas, etc).
              </p>

              <p class="text-sm font-medium text-destructive font-brand">
                Atenção! Essa ação não pode ser desfeita.
              </p>
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter class="gap-4">
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogRemove onclick={destroyTeam}>Remover</AlertDialogRemove>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </SettingsDialogGroup>
  {/if}
</SettingsDialogContent>

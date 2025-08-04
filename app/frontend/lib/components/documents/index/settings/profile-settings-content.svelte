<script lang="ts">
  import AvatarInput from '$lib/components/avatar-input.svelte'
  import { Button } from '$lib/components/ui/button'

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
  import { Input } from '$lib/components/ui/input'
  import { Label } from '$lib/components/ui/label'
  import {
    SettingsDialogContent,
    SettingsDialogGroup,
    SettingsDialogTitle,
  } from '$lib/components/ui/settings-dialog'
  import { page, router, useForm } from '@inertiajs/svelte'
  import { ChevronRight } from '@lucide/svelte'

  type FormData = {
    name: string
    avatar: File | null
  }

  let nameInput: HTMLInputElement | null = $state(null)
  let formRef: HTMLFormElement | null = $state(null)

  const user = $page.props.user

  const form = useForm<FormData>({
    name: user.name,
    avatar: null,
  })

  function submit(e: SubmitEvent) {
    e.preventDefault()
    nameInput?.blur()
    $form
      .transform(({ name, avatar }) => ({
        user: {
          name,
          avatar,
        },
      }))
      .patch('/users/profile')
  }

  function destroyUser() {
    router.delete(`/users/${user.id}`, {
      preserveState: false,
      onSuccess: () => {
        router.replace({
          clearHistory: true,
          preserveState: false,
          url: '/',
        })
      },
    })
  }
</script>

<SettingsDialogContent>
  <SettingsDialogGroup>
    <SettingsDialogTitle>Configurações do Perfil</SettingsDialogTitle>

    <form class="flex items-center gap-4" onsubmit={submit} bind:this={formRef}>
      <AvatarInput
        bind:selectedImage={$form.avatar}
        initialImage={user.avatar}
        onFileChange={() => {
          if (formRef) {
            formRef.requestSubmit()
          }
        }}
        size="sm"
      />
      <div class="flex flex-col gap-1">
        <Label class="text-xs font-medium" for="name">Nome</Label>
        <Input
          bind:ref={nameInput}
          bind:value={$form.name}
          class="w-fit bg-transparent"
          id="name"
          onfocusout={() => {
            if (formRef) {
              formRef.requestSubmit()
            }
          }}
          placeholder="Digite seu nome"
        />
      </div>
    </form>
  </SettingsDialogGroup>

  <SettingsDialogGroup>
    <SettingsDialogTitle>Segurança</SettingsDialogTitle>

    <div class="flex flex-col gap-2">
      <div class="items-center flex justify-between">
        <div class="flex flex-col gap-1">
          <p class="text-xs font-brand font-medium">Email</p>
          <p class="text-sm font-medium text-muted-foreground font-brand">
            {user.email}
          </p>
        </div>

        <AlertDialog>
          <AlertDialogTrigger>
            <Button variant="outline" size="sm" class="shadow-none h-7">
              <span>Alterar Email</span>
            </Button>
          </AlertDialogTrigger>

          <AlertDialogContent>
            <AlertDialogHeader>
              <AlertDialogTitle>Alterar Email</AlertDialogTitle>
              <AlertDialogDescription>
                Você está prestes a alterar o email da sua conta. Você precisará
                confirmar o novo email para continuar. Você tem certeza de que
                deseja continuar?
              </AlertDialogDescription>
            </AlertDialogHeader>
            <AlertDialogFooter class="gap-4">
              <AlertDialogCancel>Cancelar</AlertDialogCancel>
              <AlertDialogRemove>Confirmar</AlertDialogRemove>
            </AlertDialogFooter>
          </AlertDialogContent>
        </AlertDialog>
      </div>
    </div>
  </SettingsDialogGroup>

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
                Remover minha conta
              </p>
              <p class="text-xs font-medium text-muted-foreground font-brand">
                Remova sua conta permanentemente.
              </p>
            </div>

            <ChevronRight class="size-4 text-muted-foreground" />
          </div>
        {/snippet}
      </AlertDialogTrigger>

      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>Remover minha conta</AlertDialogTitle>
          <AlertDialogDescription class="flex flex-col gap-2">
            <p>
              Você está prestes a remover sua conta permanentemente, isso irá
              excluir sua conta de forma permanente e apagar tudo que você tem
              no workspace (documentos, pastas, etc).
            </p>

            <p class="text-sm font-medium text-destructive font-brand">
              Atenção! Essa ação não pode ser desfeita.
            </p>
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter class="gap-4">
          <AlertDialogCancel>Cancelar</AlertDialogCancel>
          <AlertDialogRemove onclick={() => destroyUser()}
            >Remover</AlertDialogRemove
          >
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  </SettingsDialogGroup>
</SettingsDialogContent>

<script lang="ts">
  import AvatarInput from '$lib/components/avatar-input.svelte'

  import { Input } from '$lib/components/ui/input'
  import { Label } from '$lib/components/ui/label'
  import { page, useForm } from '@inertiajs/svelte'

  type FormData = {
    name: string
    avatar: File | null
  }

  const user = $page.props.user

  const form = useForm<FormData>({
    name: user.name,
    avatar: null,
  })

  function submit(e: SubmitEvent) {
    e.preventDefault()
    $form
      .transform(({ name, avatar }) => ({
        user: {
          name,
          avatar,
        },
      }))
      .patch('/users/profile')
  }

  let submitButton: HTMLButtonElement | null = $state(null)
</script>

<div class="w-full divide-y divide-border flex flex-col gap-4">
  <h4 class="py-2">Configurações do Perfil</h4>

  <form class="flex items-center gap-4" onsubmit={submit}>
    <AvatarInput
      bind:selectedImage={$form.avatar}
      initialImage={user.avatar}
      onFileChange={() => submitButton?.click()}
      size="sm"
    />
    <div class="flex flex-col gap-1">
      <Label class="text-xs font-medium" for="name">Nome</Label>
      <Input
        bind:value={$form.name}
        class="w-fit bg-transparent"
        id="name"
        onfocusout={() => {
          if ($form.name.length > 0) {
            submitButton?.click()
          }
        }}
        placeholder="Digite seu nome"
      />

      <button
        aria-hidden="true"
        bind:this={submitButton}
        class="hidden"
        type="submit"
      ></button>
    </div>
  </form>
</div>

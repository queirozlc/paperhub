<script lang="ts">
  import AvatarInput from '@/lib/components/avatar-input.svelte'
  import { Button } from '@/lib/components/ui/button'
  import * as Dialog from '@/lib/components/ui/dialog/index.js'
  import { Input } from '@/lib/components/ui/input'
  import { Label } from '@/lib/components/ui/label'
  import { useForm } from '@inertiajs/svelte'
  import type { TeamForm } from './types'

  type Props = {
    cancel: () => void
  }

  let { cancel }: Props = $props()

  let form = useForm<TeamForm>({
    name: '',
    cover: null,
  })

  function submit(e: Event) {
    e.preventDefault()
    $form
      .transform(({ name, cover }) => ({
        team: { name, cover },
      }))
      .post('/teams', {
        preserveState: false,
      })
  }
</script>

<Dialog.Content class="sm:max-w-[425px]">
  <Dialog.Header class="font-brand">
    <Dialog.Title class="text-accent-foreground font-semibold"
      >Novo time</Dialog.Title
    >
    <Dialog.Description class="text-xs font-medium">
      Crie um novo time para gerenciar seus projetos, pastas e muito mais.
    </Dialog.Description>
  </Dialog.Header>
  <form
    id="team-form"
    class="flex flex-col justify-center gap-4"
    onsubmit={submit}
  >
    <AvatarInput bind:selectedImage={$form.cover} />

    <div class="space-y-2">
      <Label for="name" class="text-right">Nome</Label>
      <Input
        id="name"
        class="col-span-3"
        placeholder="Grupo TCC 2023"
        bind:value={$form.name}
      />

      {#if $form.errors.name}
        <span class="text-destructive font-medium text-sm"
          >{$form.errors.name}</span
        >
      {/if}
    </div>
  </form>
  <Dialog.Footer class="gap-4">
    <Button size="sm" class="h-7 shadow-none" variant="outline" onclick={cancel}
      >Cancelar</Button
    >
    <Button
      type="submit"
      class="h-7 shadow-none rounded-md px-4"
      size="sm"
      form="team-form">Criar time</Button
    >
  </Dialog.Footer>
</Dialog.Content>

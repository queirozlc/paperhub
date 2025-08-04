<script lang="ts">
  import { Button } from '$lib/components/ui/button'
  import {
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogDescription,
    DialogFooter,
  } from '$lib/components/ui/dialog'
  import { Input } from '$lib/components/ui/input'
  import { Label } from '$lib/components/ui/label'
  import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
  } from '$lib/components/ui/select'
  import type { InvitationForm } from '$pages/Document/types'
  import type { InertiaForm } from '@inertiajs/svelte'
  import type { HTMLAttributes } from 'svelte/elements'

  type Props = {
    onSubmit: HTMLAttributes<HTMLFormElement>['onsubmit']
    form: InertiaForm<InvitationForm>
  }

  let { onSubmit, form = $bindable(null) }: Props = $props()

  const roles = [
    {
      value: 'owner',
      label: 'Admin',
      description: 'Gerencia o time e as permissões dos membros.',
    },
    {
      value: 'member',
      label: 'Membro',
      description: 'Pode editar e visualizar os documentos do time.',
    },
  ]

  let triggerContent = $derived(
    roles.find((role) => role.value === form.role)?.label ??
      'Selecione um cargo'
  )
</script>

<DialogContent>
  <DialogHeader>
    <DialogTitle class="text-base">Convidar novos membros</DialogTitle>
    <DialogDescription>
      Adicione os emails dos membros que você deseja convidar para o seu time.
    </DialogDescription>
  </DialogHeader>

  <form
    autocomplete="off"
    class="flex flex-col gap-4"
    id="invite-form"
    onsubmit={onSubmit}
  >
    <div class="flex flex-col gap-1">
      <Label class="text-xs font-medium text-muted-foreground" for="email"
        >Endereços de e-mail</Label
      >
      <Input
        bind:value={form.email}
        type="email"
        class="ring-0 relative peer"
        data-error={form.errors.email}
        id="email"
        placeholder="email@exemplo.com"
        required
      />
      <span class="text-xs text-red-500 peer-data-[error]:block hidden">
        {form.errors.email}
      </span>
    </div>

    <div class="flex flex-col gap-1">
      <Label class="text-xs font-medium text-muted-foreground" for="role"
        >Cargo</Label
      >

      <Select name="role" type="single" bind:value={form.role} required>
        <SelectTrigger class="w-full">
          {triggerContent}
        </SelectTrigger>

        <SelectContent>
          {#each roles as role (role.value)}
            <SelectItem value={role.value}>{role.label}</SelectItem>
          {/each}
        </SelectContent>
      </Select>

      {#if form.role}
        <p class="text-xs text-muted-foreground">
          {roles.find((role) => role.value === form.role)?.description}
        </p>
      {:else}
        <p class="text-xs text-muted-foreground">
          Selecione um cargo para ver a descrição.
        </p>
      {/if}
    </div>
  </form>

  <DialogFooter>
    <Button
      class="font-brand px-2"
      disabled={form.processing}
      form="invite-form"
      size="sm"
      type="submit">Enviar convite</Button
    >
  </DialogFooter>
</DialogContent>

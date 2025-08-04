<script lang="ts">
  import { Button } from '$lib/components/ui/button'
  import { Dialog, DialogTrigger } from '$lib/components/ui/dialog'
  import type { InvitationForm } from '$pages/Document/types'
  import { type InertiaForm } from '@inertiajs/svelte'
  import { UserPlus01 } from '@voolt_technologies/untitledui-svelte'
  import { InvitationDialogContent } from './invitation-dialog'

  type Props = {
    form: InertiaForm<InvitationForm>
    sendInvite: (e: SubmitEvent) => void
    open: boolean
  }

  let {
    sendInvite,
    form = $bindable(null),
    open = $bindable(false),
  }: Props = $props()
</script>

<Dialog bind:open>
  <DialogTrigger>
    <Button class="w-full" size="sm" variant="outline">
      <UserPlus01 />
      Convidar novos membros
    </Button>
  </DialogTrigger>

  <InvitationDialogContent bind:form onSubmit={sendInvite} />
</Dialog>

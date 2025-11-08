<script lang="ts">
  import { Button } from '$lib/components/ui/button'
  import { Input } from '$lib/components/ui/input'
  import { Textarea } from '$lib/components/ui/textarea'
  import { Label } from '$lib/components/ui/label'
  import type { SnapshotManager } from '$lib/sync'
  import { toast } from 'svelte-sonner'

  let {
    snapshotManager,
    workspaceId,
  }: {
    snapshotManager: SnapshotManager
    workspaceId: number
  } = $props()

  let message = $state('')
  let description = $state('')
  let isCreating = $state(false)

  async function handleSubmit(e: SubmitEvent) {
    e.preventDefault()

    if (!message.trim()) {
      toast.error('Message is required')
      return
    }

    isCreating = true
    try {
      // Create snapshot - will redirect to snapshots page on success
      await snapshotManager.createSnapshot({
        message,
        description,
        workspaceId,
      })
      // Note: redirect happens in SnapshotsController, so we won't reach here on success
    } catch (error) {
      console.error('Failed to create snapshot:', error)
      toast.error('Failed to create snapshot')
      isCreating = false
    }
  }
</script>

<form onsubmit={handleSubmit} class="space-y-4">
  <div>
    <Label for="message">Snapshot Message</Label>
    <Input
      id="message"
      bind:value={message}
      placeholder="Describe this version..."
      required
      disabled={isCreating}
      class="text-sm shadow h-9"
    />
  </div>

  <div>
    <Label for="description">Description (optional)</Label>
    <Textarea
      id="description"
      bind:value={description}
      placeholder="Add some details (optional)..."
      disabled={isCreating}
      class="resize-none pb-10 no-scrollbar"
    />
  </div>

  <Button type="submit" disabled={isCreating} class="w-full">
    {isCreating ? 'Creating...' : 'Create Snapshot'}
  </Button>
</form>

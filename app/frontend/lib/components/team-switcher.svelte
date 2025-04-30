<script lang="ts">
  import * as DropdownMenu from '@/lib/components/ui/dropdown-menu'
  import * as Sidebar from '@/lib/components/ui/sidebar'
  import * as Dialog from '@/lib/components/ui/dialog'
  import TeamForm from '@/pages/Team/Form.svelte'
  import type { TeamType } from '@/pages/Team/types'
  import { router } from '@inertiajs/svelte'
  import { ChevronDown, Plus } from '@lucide/svelte'
  import { defaultAvatar } from '../utils'
  import { Check } from '@voolt_technologies/untitledui-svelte'

  let { teams }: { teams: TeamType[] } = $props()

  let activeTeam = $state(teams[0])
  let open = $state(false)

  function logout() {
    router.delete('/sign_out')
  }

  function cancel() {
    open = false
  }
</script>

<Sidebar.Menu>
  <Sidebar.MenuItem>
    <Dialog.Root {open} onOpenChange={(value) => (open = value)}
      ><DropdownMenu.Root>
        <DropdownMenu.Trigger>
          {#snippet child({ props })}
            <Sidebar.MenuButton {...props} class="w-fit px-1.5">
              <div
                class="text-sidebar-primary-foreground flex aspect-square size-5 items-center justify-center rounded-md"
              >
                <img
                  alt="fallback active team cover"
                  src={defaultAvatar(activeTeam.id).toDataUri()}
                  class="size-5 rounded"
                />
              </div>
              <span class="truncate font-semibold font-brand"
                >Time {activeTeam.name}</span
              >
              <ChevronDown class="opacity-50" />
            </Sidebar.MenuButton>
          {/snippet}
        </DropdownMenu.Trigger>

        <DropdownMenu.Content
          class="w-64 rounded-lg"
          align="start"
          side="bottom"
          sideOffset={4}
        >
          <DropdownMenu.Label
            class="text-muted-foreground font-brand pointer-events-none text-xs"
            >Times</DropdownMenu.Label
          >
          {#each teams as team, index (team.id)}
            <DropdownMenu.Item
              onSelect={() => (activeTeam = team)}
              class="gap-2 p-2"
            >
              <div
                class="flex size-6 items-center justify-center rounded-sm border"
              >
                <img
                  alt="fallback team cover"
                  src={defaultAvatar(team.id).toDataUri()}
                  class="size-5 shrink-0 rounded-sm"
                />
              </div>
              <span
                class="truncate grow font-medium font-brand text-sm text-muted-foreground"
                >{team.name}</span
              >
              <div class="flex items-center gap-2">
                <DropdownMenu.Shortcut>⌘{index + 1}</DropdownMenu.Shortcut>
                {#if team.id === activeTeam.id}
                  <Check class="size-4 text-muted-foreground" />
                {/if}
              </div>
            </DropdownMenu.Item>
          {/each}

          <DropdownMenu.Separator />

          <Dialog.Trigger class="w-full">
            <DropdownMenu.Item class="gap-2 p-2">
              <div
                class="bg-background flex size-6 items-center justify-center rounded-md border"
              >
                <Plus class="size-4" />
              </div>
              <div class="text-muted-foreground font-medium">Add team</div>
            </DropdownMenu.Item>
          </Dialog.Trigger>

          <DropdownMenu.Separator />

          <DropdownMenu.Item
            onclick={logout}
            class="font-semibold text-xs text-muted-foreground px-2"
            >Log out</DropdownMenu.Item
          >
        </DropdownMenu.Content>
      </DropdownMenu.Root>

      <TeamForm {cancel} />
    </Dialog.Root>
  </Sidebar.MenuItem>
</Sidebar.Menu>

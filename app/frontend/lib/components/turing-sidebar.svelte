<script lang="ts">
  import * as Sidebar from '@/lib/components/ui/sidebar'
  import { InfoCircle } from '@voolt_technologies/untitledui-svelte'
  import type { ComponentProps } from 'svelte'
  import Button from './ui/button/button.svelte'

  type Props = ComponentProps<typeof Sidebar.Root>

  let { ref = $bindable(null), ...restProps }: Props = $props()
</script>

<Sidebar.Provider
  name="turing"
  class="w-fit overflow-hidden max-h-dvh"
  open={true}
  style="--sidebar-width: 18rem;"
>
  <Sidebar.Root bind:ref side="right" {...restProps} transparent>
    <Sidebar.Header class="border-sidebar-border h-14 border-b"
    ></Sidebar.Header>
    <Sidebar.Content>
      <Sidebar.Group>
        <div class="flex items-center justify-between">
          <span class="text-muted-foreground text-sm font-semibold font-brand"
            >Turing AI</span
          >
          <Button
            size="icon"
            variant="ghost"
            class="hover:text-accent-foreground text-muted-foreground"
          >
            <InfoCircle class="size-4" />
          </Button>
        </div>
      </Sidebar.Group>
    </Sidebar.Content>
  </Sidebar.Root>
</Sidebar.Provider>

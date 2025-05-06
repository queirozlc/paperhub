<script lang="ts">
  import * as Sidebar from '@/lib/components/ui/sidebar'
  import { InfoCircle } from '@voolt_technologies/untitledui-svelte'
  import Button from './ui/button/button.svelte'
</script>

<Sidebar.Root side="right" transparent>
  <Sidebar.Header class="border-sidebar-border h-14 border-b"></Sidebar.Header>
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

<script module>
  export { default as Layout } from './Layout.svelte'
</script>

<script lang="ts">
  import { initializeSidebarRegistry } from '$lib/components/ui/sidebar/registry.svelte'

  import { ModeWatcher } from 'mode-watcher'

  let { children } = $props()

  initializeSidebarRegistry()
</script>

<ModeWatcher />
{@render children()}

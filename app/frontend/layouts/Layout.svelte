<script module>
  export { default as Layout } from './Layout.svelte'
</script>

<script lang="ts">
  import { initializeSidebarRegistry } from '$lib/components/ui/sidebar/registry.svelte'
  import { Toaster } from '$lib/components/ui/sonner'
  import { router } from '@inertiajs/svelte'

  import { ModeWatcher } from 'mode-watcher'

  let { children } = $props()

  initializeSidebarRegistry()

  function reloadDeps(event: PopStateEvent) {
    event.stopImmediatePropagation()

    router.reload({
      except: ['flash'],
    })
  }
</script>

<svelte:window onpopstate={reloadDeps} />

<ModeWatcher />
<Toaster />
{@render children()}

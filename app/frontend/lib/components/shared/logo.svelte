<script lang="ts">
  import logo from '$assets/images/logo.png'
  import logoDark from '$assets/images/logo-dark.png'
  import { cn } from '$lib/utils'

  import type { HTMLImgAttributes } from 'svelte/elements'

  let { class: className, ...rest }: HTMLImgAttributes = $props()
</script>

<img
  src={logo}
  alt="Paperhub Logo"
  class={cn('dark:hidden w-36', className)}
  {...rest}
/>

<img
  src={logoDark}
  alt="Paperhub Logo"
  class={cn('hidden w-36 dark:block', className)}
  {...rest}
/>

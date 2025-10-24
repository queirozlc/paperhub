<script lang="ts">
  import { SidebarTrigger } from '$lib/components/ui/sidebar'
  import { Separator } from '$lib/components/ui/separator'
  import type { ComponentProps } from 'svelte'
  import { SIDEBAR_COOKIE_NAME } from '$lib/components/ui/sidebar/constants'

  type Props = ComponentProps<typeof SidebarTrigger>

  let { for: htmlFor = SIDEBAR_COOKIE_NAME, ...restProps }: Props = $props()
</script>

<div class="flex items-center gap-2">
  <SidebarTrigger for={htmlFor} {...restProps} />
  <Separator class="mr-2 h-4" orientation="vertical" />
</div>

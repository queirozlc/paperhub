<script lang="ts">
  import * as Tooltip from '$lib/components/ui/tooltip'
  import * as Avatar from '$lib/components/ui/avatar'
  import { page } from '@inertiajs/svelte'
  import { defaultAvatar } from '../utils'

  const user = $page.props.user
</script>

<div class="flex -space-x-3 rtl:space-x-reverse">
  <Tooltip.Trigger>
    <Avatar.Root class="size-7">
      <Avatar.Image src={user.avatar} alt={`${user.email}'s avatar`} />

      <Avatar.Fallback>
        <img
          src={defaultAvatar(user.id).toDataUri()}
          alt="Default fallback avatar"
        />
      </Avatar.Fallback>
    </Avatar.Root>
  </Tooltip.Trigger>
</div>

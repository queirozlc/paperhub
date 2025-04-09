<script lang="ts">
  import Button from '@/lib/components/ui/button/button.svelte'
  import { router } from '@inertiajs/svelte'

  function logout() {
    router.delete('/sign_out')
  }
</script>

<Button onclick={logout}>Logout</Button>

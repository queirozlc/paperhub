<script lang="ts">
  import { Button } from '$lib/components/ui/button'
  import { Link } from '@inertiajs/svelte'
</script>

<div class="flex flex-col items-center justify-center h-screen">
  <h1 class="text-4xl font-bold">Welcome</h1>
  <Link href={'/sign_in'} class="mt-4">
    <Button>Sign in</Button>
  </Link>
</div>

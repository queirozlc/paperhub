<script lang="ts">
  import { Button } from '$lib/components/ui/button'
  import { Link } from '@inertiajs/svelte'
</script>

<div class="flex flex-col items-center justify-center h-screen">
  <h1 class="text-4xl font-bold">Bem-vindo</h1>
  <h3 class="text-accent-foregorund text-center mt-2">
    🚧 Página em construção... 🚧
  </h3>
  <span class="text-muted-foreground text-center mt-2">
    Ainda estamos implementando algumas funcionalidades no sistema
  </span>
  <span class="text-muted-foreground text-center">
    mas fique à vontade para explorar o que já está disponível!
  </span>
  <Link href="/users/sign_in" class="mt-4">
    <Button>Ir para Login</Button>
  </Link>
</div>

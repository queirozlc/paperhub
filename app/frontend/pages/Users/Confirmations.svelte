<script lang="ts">
  import { Logo } from '$lib/components/shared'
  import { Button } from '$lib/components/ui/button'
  import { Link } from '@inertiajs/svelte'
  import { ArrowLeft, ArrowUpRight } from '@lucide/svelte'

  type Props = {
    email: string
  }

  let { email }: Props = $props()

  const isGmail = (email: string) => email.endsWith('@gmail.com')
</script>

<svelte:head>
  <title>Confirmação de e-mail</title>
  <meta
    name="description"
    content="Confirme seu e-mail para continuar com o cadastro."
  />
</svelte:head>

<div class="bg-background-off grid min-h-screen">
  <section
    class="flex w-full justify-center px-8 py-16 md:mb-32 md:items-center"
  >
    <div class="space-y-6">
      <Link href="/users/sign_in" replace class="inline-block">
        <div
          class="font-brand bg-background dark:bg-muted border-muted-foreground/10 hover:inset-shadow-md flex h-8 items-center gap-1 rounded-lg border-[.5px] px-3 text-sm font-semibold inset-shadow-sm shadow-md hover:shadow-lg"
        >
          <ArrowLeft class="size-4" />
          <span class="text-nowrap">Voltar</span>
        </div>
      </Link>
      <div
        class="border-muted-foreground/10 bg-background dark:bg-muted shadow-card w-full max-w-lg overflow-hidden rounded-3xl border-[0.5px]"
      >
        <div
          class="border-muted-foreground/10 flex items-center justify-center border-b px-16 py-6"
        >
          <Logo class="w-32" />
        </div>

        <div class="space-y-6 p-6 text-center md:p-12">
          <h1
            class="font-brand text-2xl font-bold lg:text-3xl lg:tracking-tight"
          >
            Bem-vindo! Agora é só confirmar o seu e-mail 🎉
          </h1>

          <p class="text-muted-foreground/60">
            Enviamos um e-mail para
            <span class="text-accent-foreground font-semibold">
              {email}
            </span>
            com um link para verificação. Clique no link para continuar.
          </p>

          {#if isGmail(email)}
            <a
              target="__blank"
              href="https://mail.google.com/mail/u/0/#search/from%3APaperhub%20%3Chello%40resend.paperhub.app%3E"
            >
              <Button
                type="submit"
                class="font-brand border-primary outline-primary ring-primary shadow-primary inset-shadow-primary h-12 w-full text-lg font-semibold duration-200 ease-in-out hover:ring-2 hover:shadow-[1px_1px_2px_var(--color-primary)] hover:outline-1 focus-visible:ring-2 focus-visible:outline-2"
              >
                Checar inbox <ArrowUpRight class="size-6" />
              </Button>
            </a>
          {/if}
        </div>
      </div>
    </div>
  </section>
</div>

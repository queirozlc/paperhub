<script module>
  import scribbleDark from '$assets/images/scribble-dark.svg'
  import scribble from '$assets/images/scribble.svg'
  import reading from '$assets/images/reading.png'
  import readingDark from '$assets/images/reading-dark.png'
  import documents from '$assets/images/documents.png'
  import documentsDark from '$assets/images/documents-dark.png'
</script>

<script lang="ts">
  import { Button } from '$lib/components/ui/button'
  import { ArrowRight, LoaderIcon } from '@lucide/svelte'
  import { Logo } from '$lib/components/shared'
  import { Input } from '$lib/components/ui/input'
  import { page, useForm } from '@inertiajs/svelte'
  import { capitalize } from '$lib/utils'
  import type { UserType } from './types'

  const form = useForm({
    name: '',
  })

  function submit(e: SubmitEvent) {
    e.preventDefault()
    $form
      .transform(({ name }) => ({
        user: { name },
      }))
      .patch('/onboarding')
  }

  const user = $page.props.user as UserType

  const placeholder = capitalize(user.email.split('@')[0])
</script>

<section
  class="bg-background-off flex h-screen w-full items-start justify-center lg:flex-row lg:gap-10"
>
  <div
    class="font-brand flex grow-1 flex-col justify-center space-y-10 px-6 pt-24"
  >
    <Logo class="w-32" />

    <h1 class="text-accent-foreground">Vamos preparar o seu perfil 🚀</h1>

    <div class="space-y-2">
      <h2 class="text-accent-foreground">
        Queremos te conhecer melhor, qual seu nome?
      </h2>
      <p class="text-muted-foreground">
        É assim que você será chamado por aqui
      </p>
    </div>

    <form onsubmit={submit} id="update-name">
      <Input
        required
        id="name"
        class={[
          'h-12',
          $form.errors.name &&
            $form.isDirty &&
            'border-destructive outline-destructive',
        ]}
        {placeholder}
        bind:value={$form.name}
        autofocus
      />
    </form>

    <span class="text-muted-foreground text-sm">
      Não se preocupe, você poderá alterar isso a qualquer momento
    </span>

    <Button
      form="update-name"
      type="submit"
      class="h-12 w-full gap-2 text-lg"
      disabled={$form.processing}
    >
      {#if $form.processing}
        <LoaderIcon class="size-5 animate-spin" />
      {:else}
        Continuar
        <ArrowRight class="size-5" />
      {/if}
    </Button>
  </div>

  <div
    class="bg-muted shadow-[0px 0px 20px rgba(0,0,0,0.1)] border-background-off hidden h-full grow flex-col items-center justify-center border-l lg:flex"
  >
    <img
      src={reading}
      alt="Ilustração de uma mulher lendo um livro"
      class="max-w-md dark:hidden"
    />

    <img
      src={readingDark}
      alt="Ilustração de uma mulher lendo um livro"
      class="hidden max-w-md dark:block"
    />

    <img
      src={documents}
      alt="Ilustração de uma mulher lendo um livro"
      class="max-w-md dark:hidden"
    />

    <img
      src={documentsDark}
      alt="Ilustração de uma mulher lendo um livro"
      class="hidden max-w-md dark:block"
    />

    <img
      src={scribble}
      alt="Ilustração de uma mulher lendo um livro"
      class="size-24 rotate-90 rotate-x-180 dark:hidden"
    />

    <img
      src={scribbleDark}
      alt="Ilustração de uma mulher lendo um livro"
      class="hidden size-24 -rotate-90 dark:block"
    />
  </div>
</section>

<script lang="ts">
  import { Button } from '@/lib/components/ui/button'
  import { Input } from '@/lib/components/ui/input'
  import { Label } from '@/lib/components/ui/label'
  import { cn } from '@/lib/utils'
  import { useForm } from '@inertiajs/svelte'
  import { LoaderIcon, Mail } from '@lucide/svelte'
  import logo from '@/assets/images/logo.png'
  import logoDark from '@/assets/images/logo-dark.png'

  const form = useForm<{ email: '' }>({
    email: '',
  })

  const submit = (e: SubmitEvent) => {
    e.preventDefault()
    $form
      .transform((data) => ({
        user: { ...data },
      }))
      .post('/sign_in')
  }
</script>

<div class="mb-8 flex items-center justify-center">
  <img src={logo} alt="Paperhub Logo" class="w-36 dark:hidden" />

  <img src={logoDark} alt="Paperhub Logo" class="hidden w-36 dark:block" />
</div>

<div>
  <Button
    class="font-brand text-accent dark:text-accent-foreground active:animate-button-pop h-12 w-full border bg-[hsl(223.81,0%,16%)] text-lg font-semibold shadow-[1px_1px_2px_rgba(0,0,0,0.1)] duration-200 ease-in-out hover:bg-[hsl(223.81,0%,16%)]/80 dark:bg-[hsl(223.81,0%,30%)]/80 dark:hover:bg-[hsl(223.81,0%,30%)]/60"
  >
    <svg
      data-testid="geist-icon"
      stroke-linejoin="round"
      viewBox="0 0 16 16"
      class="size-6"
    >
      <path
        d="M8.15991 6.54543V9.64362H12.4654C12.2763 10.64 11.709 11.4837 10.8581 12.0509L13.4544 14.0655C14.9671 12.6692 15.8399 10.6182 15.8399 8.18188C15.8399 7.61461 15.789 7.06911 15.6944 6.54552L8.15991 6.54543Z"
        fill="#4285F4"
      ></path>
      <path
        d="M3.6764 9.52268L3.09083 9.97093L1.01807 11.5855C2.33443 14.1963 5.03241 16 8.15966 16C10.3196 16 12.1305 15.2873 13.4542 14.0655L10.8578 12.0509C10.1451 12.5309 9.23598 12.8219 8.15966 12.8219C6.07967 12.8219 4.31245 11.4182 3.67967 9.5273L3.6764 9.52268Z"
        fill="#34A853"
      ></path>
      <path
        d="M1.01803 4.41455C0.472607 5.49087 0.159912 6.70543 0.159912 7.99995C0.159912 9.29447 0.472607 10.509 1.01803 11.5854C1.01803 11.5926 3.6799 9.51991 3.6799 9.51991C3.5199 9.03991 3.42532 8.53085 3.42532 7.99987C3.42532 7.46889 3.5199 6.95983 3.6799 6.47983L1.01803 4.41455Z"
        fill="#FBBC05"
      ></path>
      <path
        d="M8.15982 3.18545C9.33802 3.18545 10.3853 3.59271 11.2216 4.37818L13.5125 2.0873C12.1234 0.792777 10.3199 0 8.15982 0C5.03257 0 2.33443 1.79636 1.01807 4.41455L3.67985 6.48001C4.31254 4.58908 6.07983 3.18545 8.15982 3.18545Z"
        fill="#EA4335"
      ></path>
    </svg>
    Entrar com google
  </Button>
</div>

<div
  class="text-muted-foreground before:bg-accent after:bg-accent font-brand my-4 flex h-4 items-center gap-4 text-sm whitespace-nowrap before:h-[1px] before:w-full after:h-[1px] after:w-full"
>
  Ou
</div>

<form class={cn('flex flex-col gap-6')} onsubmit={submit}>
  <div class="grid gap-6">
    <div class="grid gap-2">
      <Label for="email" class="font-brand">Email</Label>
      <Input
        bind:value={$form.email}
        id="email"
        class="font-brand h-12"
        type="email"
        placeholder="m@example.com"
        required
      />
    </div>
    <Button
      type="submit"
      class="font-brand h-12 w-full text-lg font-semibold"
      disabled={$form.processing}
    >
      {#if $form.processing}
        <LoaderIcon class="size-5 animate-spin" />
      {:else}
        <span>Continuar com e-mail</span>
        <Mail class="size-5" />
      {/if}
    </Button>
  </div>
</form>

<style>
  svg {
    color: currentColor;
  }
</style>

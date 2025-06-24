<script lang="ts">
  import { Button } from './ui/button'
  import { Switch } from './ui/switch'
  import Input from './ui/input/input.svelte'

  type Props = {
    protocol: string
    url: string
    openInNewTab: boolean
    onSubmit: () => void
  }

  let {
    protocol = $bindable(''),
    url = $bindable(''),
    openInNewTab = $bindable(false),
    onSubmit,
  }: Props = $props()

  function handleSubmit(e: SubmitEvent) {
    e.preventDefault()
    onSubmit()
  }
</script>

<div class="rounded-lg flex flex-col gap-4 p-4 w-full">
  <form class="flex items-center gap-2 relative" onsubmit={handleSubmit}>
    <div class="flex rounded-md shadow-xs">
      <div class="relative flex">
        <select
          bind:value={protocol}
          class="peer border-input outline-none focus-visible:ring-0 has-[option[disabled]:checked]:text-muted-foreground inline-flex cursor-pointer appearance-none items-center rounded-md border text-sm transition-[color,box-shadow] disabled:pointer-events-none text-muted-foreground hover:text-foreground w-fit rounded-e-none shadow-none bg-background h-9"
        >
          <option value="https://">https://</option>
          <option value="http://">http://</option>
        </select>
      </div>
      <Input
        bind:value={url}
        class="rounded-s-none grow shadow-none focus-visible:ring-0 outline-none"
        placeholder="google.com"
        autocomplete="off"
      />
    </div>

    <Button size="sm" type="submit">Inserir Link</Button>
  </form>
  <div class="flex items-center gap-2">
    <label
      class="flex items-center justify-start gap-2 text-sm font-semibold cursor-pointer select-none text-neutral-500 dark:text-neutral-400"
      for="open-in-new-tab"
    >
      Abrir em uma nova aba
    </label>
    <Switch
      bind:checked={openInNewTab}
      class="cursor-pointer"
      id="open-in-new-tab"
    />
  </div>
</div>

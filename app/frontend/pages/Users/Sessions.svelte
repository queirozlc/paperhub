<script lang="ts" module>
  import appDemo from '$assets/minimal_demo.mp4'
</script>

<script lang="ts">
  import Form from './Form.svelte'
</script>

<div class="bg-background-off grid h-screen lg:grid-cols-12">
  <div
    class="relative hidden lg:block border-border/40 col-span-6 h-full w-full overflow-hidden border-r shadow-[1px_0_16px_rgba(0,0,0,0.05)] brightness-90 max-lg:hidden dark:brightness-75"
  >
    <video autoplay muted loop class="size-full hidden lg:block object-cover">
      <source src={appDemo} type="video/mp4" />
    </video>
  </div>
  <section
    class="col-span-6 flex w-full flex-col items-center justify-center gap-4 px-8 py-16"
  >
    <div
      class="border-border bg-background/30 w-full max-w-lg overflow-hidden rounded-3xl border-[0.5px] p-8 shadow-[1px_1px_8px_rgba(0,0,0,0.1)]"
    >
      <Form />
    </div>
  </section>
</div>

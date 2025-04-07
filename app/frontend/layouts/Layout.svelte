<script module>
  export { default as Layout } from './Layout.svelte'
</script>

<script lang="ts">
  let { children } = $props()
</script>

<h1>Hello world</h1>

{@render children()}

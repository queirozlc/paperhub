<script lang="ts">
  type Props = {
    question: string
  }

  let { question }: Props = $props()
</script>

<div class="ml-4 self-end">
  <span class="block opacity-50 text-xs text-right">você</span>
  <p class="w-full m-0">{question}</p>
</div>

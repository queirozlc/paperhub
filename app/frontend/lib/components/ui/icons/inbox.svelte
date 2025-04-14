<script lang="ts">
  import { cn } from '@/lib/utils'
  import type { SVGAttributes } from 'svelte/elements'

  type Props = SVGAttributes<SVGElement>

  let { class: className, ...restProps }: Props = $props()
</script>

<svg
  xmlns="http://www.w3.org/2000/svg"
  width="20"
  height="20"
  viewBox="0 0 20 20"
  fill="none"
  class={cn('size-4', className)}
  {...restProps}
>
  <path
    d="M18.3333 9.99992H13.3333L11.6667 12.4999H8.33333L6.66666 9.99992H1.66666M18.3333 9.99992V14.9999C18.3333 15.4419 18.1577 15.8659 17.8452 16.1784C17.5326 16.491 17.1087 16.6666 16.6667 16.6666H3.33333C2.8913 16.6666 2.46738 16.491 2.15482 16.1784C1.84226 15.8659 1.66666 15.4419 1.66666 14.9999V9.99992M18.3333 9.99992L15.4583 4.25825C15.3203 3.98057 15.1076 3.74689 14.8441 3.58348C14.5806 3.42008 14.2767 3.33342 13.9667 3.33325H6.03333C5.72326 3.33342 5.41938 3.42008 5.15587 3.58348C4.89235 3.74689 4.67965 3.98057 4.54166 4.25825L1.66666 9.99992"
    stroke="currentColor"
    stroke-width="2"
    stroke-linecap="round"
    stroke-linejoin="round"
  />
</svg>

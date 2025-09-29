<script lang="ts">
  import { cn } from '$lib/utils'
  import type { SVGAttributes } from 'svelte/elements'
  import { ICONS, type IconName } from './registry'

  type SvgAttributes = Omit<SVGAttributes<SVGSVGElement>, 'name'>

  type Props = {
    name: IconName
    strokeWidth?: number
    size?: number
    pathFill?: string
  } & SvgAttributes

  let {
    name,
    class: className = '',
    strokeWidth = 1.5,
    size = 20,
    stroke = 'currentColor',
    fill = 'none',
    pathFill = 'none',
    ...restProps
  }: Props = $props()

  const icon = ICONS[name]

  if (!icon) {
    console.warn(`Icon "${name}" not found in registry`)
  }

  const viewBox = icon?.viewBox || '0 0 20 20'
</script>

{#if icon}
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width={size}
    height={size}
    {...restProps}
    {viewBox}
    {fill}
    class={cn('inline-block', className)}
    aria-hidden="true"
  >
    {#if Array.isArray(icon.path)}
      {#each icon.path as pathData (pathData)}
        <path
          d={pathData}
          {stroke}
          stroke-width={strokeWidth}
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      {/each}
    {:else}
      <path
        d={icon.path}
        {stroke}
        stroke-width={strokeWidth}
        stroke-linecap="round"
        stroke-linejoin="round"
        fill={pathFill}
      />
    {/if}
  </svg>
{/if}

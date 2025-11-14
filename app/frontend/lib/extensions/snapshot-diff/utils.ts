export type YChange = {
  user: string | null
  type: 'added' | 'removed' | null
  color: {
    light: string
    dark: string
  } | null
}

export function calcYChangeStyle(ychange: YChange): string {
  if (!ychange || !ychange.type) return ''
  switch (ychange.type) {
    case 'removed':
      return `color:${ychange.color?.dark ?? ''}`
    case 'added':
      return `background-color:${ychange.color?.light ? '' + ychange.color.light : ''}`
    default:
      return ''
  }
}

export function calcYchangeDomAttrs(
  attrs: { ychange: YChange | null },
  domAttrs: Record<string, string> = {}
): Record<string, string> {
  domAttrs = Object.assign({}, domAttrs)
  if (attrs.ychange !== null) {
    domAttrs.ychange_user = attrs.ychange.user
    domAttrs.ychange_type = attrs.ychange.type
    domAttrs.ychange_color = attrs.ychange.color.light
    domAttrs.style = calcYChangeStyle(attrs.ychange)
  }
  return domAttrs
}

export function hoverWrapper(
  ychange: Record<string, string> | null,
  children: unknown[]
): unknown[] {
  if (!ychange) return children
  // Mirror original structure:
  return [
    [
      'span',
      {
        class: 'ychange-hover',
        style: `background-color:${ychange.color?.dark ?? ''}`,
      },
      ychange.user || 'Unknown',
    ],
    ['span', ...children],
  ]
}

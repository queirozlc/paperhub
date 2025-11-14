/**
 * YChange Extension - Adds ychange attribute support to all nodes and marks
 * This extension must be loaded to enable snapshot diff rendering
 */
import { Extension, Mark } from '@tiptap/core'

export interface YChangeData {
  user: string | null
  type: 'added' | 'removed' | null
  color: {
    light: string
    dark: string
  }
}

const calcYChangeStyle = (ychange: YChangeData | null): string => {
  if (!ychange) return ''

  switch (ychange.type) {
    case 'removed':
      return `color:${ychange.color.dark};text-decoration:line-through;`
    case 'added':
      return `background-color:${ychange.color.light};`
    default:
      return ''
  }
}

const calcYChangeDomAttrs = (
  ychange: YChangeData | null,
  existingAttrs: Record<string, unknown> = {}
): Record<string, unknown> => {
  const attrs = { ...existingAttrs }

  console.log({ ychange, attrs })

  if (ychange) {
    attrs['ychange_user'] = ychange.user
    attrs['ychange_type'] = ychange.type
    attrs['ychange_color'] = ychange.color.light

    // Merge with existing style if present
    const existingStyle = attrs.style || ''
    const ychangeStyle = calcYChangeStyle(ychange)
    attrs.style = existingStyle
      ? `${existingStyle};${ychangeStyle}`
      : ychangeStyle
  }

  return attrs
}

const YChangeMarks = Mark.create({
  name: 'ychange_mark',
  addGlobalAttributes() {
    return [
      {
        types: ['textStyle'],
        attributes: {
          ychange: {
            default: null,
          },
        },
      },
    ]
  },
})

export const YChange = Extension.create({
  name: 'ychange',

  addGlobalAttributes() {
    return [
      {
        // Add ychange attribute to ALL nodes
        types: [
          'paragraph',
          'heading',
          'blockquote',
          'codeBlock',
          'bulletList',
          'orderedList',
          'listItem',
          'horizontalRule',
          'hardBreak',
          'image',
          'table',
          'tableRow',
          'tableCell',
          'tableHeader',
          // Add any other custom nodes you have
        ],
        attributes: {
          ychange: {
            default: null,
            parseHTML: (element) => {
              const user = element.getAttribute('ychange_user')
              const type = element.getAttribute('ychange_type')
              const colorLight = element.getAttribute('ychange_color')

              if (!user || !type || !colorLight) return null

              // Try to derive dark color from light color
              // This is a simple approximation
              const colorDark = colorLight.replace('33', '')

              return {
                user,
                type: type as 'added' | 'removed',
                color: {
                  light: colorLight,
                  dark: colorDark,
                },
              }
            },
            renderHTML: (attributes) => {
              const ychange = attributes.ychange as YChangeData | null
              if (!ychange) return {}

              // render more than just the attributes, also render the tag itself and possible hover wrapper
              return calcYChangeDomAttrs(ychange, attributes)
            },
          },
        },
      },
    ]
  },

  addExtensions() {
    return [YChangeMarks]
  },
})

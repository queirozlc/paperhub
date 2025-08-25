export { cn } from './cn'
export { isCustomNodeSelected } from './custom-node'
export { defaultAvatar } from './default-avatar'
export { getOS } from './os-picker'
export { isTextSelected } from './text-selection'

export type HashableModel = {
  sqid: string
}

export const capitalize = (str: string) =>
  str.charAt(0).toUpperCase() + str.slice(1)

export const userNameFallback = (name: string) =>
  name
    .split(' ')
    .map((n) => n.charAt(0).toUpperCase())
    .join('')

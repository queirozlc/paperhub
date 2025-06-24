export { cn } from './cn'
export { getOS } from './os-picker'
export { defaultAvatar } from './default-avatar'
export { isCustomNodeSelected } from './custom-node'
export { isTextSelected } from './text-selection'

export type HashableModel = {
  sqid: string
}

export const capitalize = (str: string) =>
  str.charAt(0).toUpperCase() + str.slice(1)

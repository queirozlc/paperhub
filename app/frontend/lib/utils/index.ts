export { cn } from './cn'
export { isCustomNodeSelected } from './custom-node'
export { debounce } from './debounce'
export { defaultAvatar } from './default-avatar'
export { diffHtml } from './diff'
export { getOS } from './os-picker'
export {
  setIdsToNewAiSuggestions,
  extractNodeHtmlContent,
} from './ai-suggestion'
export { isTextSelected } from './text-selection'
export { displayUnavailableFunctionalityToast } from './toast'

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

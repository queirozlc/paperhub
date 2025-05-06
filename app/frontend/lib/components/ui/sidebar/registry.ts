import { getContext, setContext } from 'svelte'
import { SIDEBAR_COOKIE_NAME } from './constants'
import type { SidebarState } from './context.svelte'

const SIDEBAR_REGISTRY_KEY = Symbol('sidebar-registry')

export class SidebarRegistry {
  private registry: Map<string, SidebarState> = new Map()

  register(state: SidebarState, key: string = SIDEBAR_COOKIE_NAME) {
    if (this.registry.has(key)) {
      console.warn(`Sidebar with name "${key}" is already registered.`)
      return
    }

    this.registry.set(key, state)
  }

  get(key: string = SIDEBAR_COOKIE_NAME): SidebarState | undefined {
    const state = this.registry.get(key)
    if (!state) {
      console.warn(`Sidebar with name "${key}" is not registered.`)
      return
    }
    return state
  }
}

export function initializeSidebarRegistry() {
  const registry = new SidebarRegistry()
  if (getContext(SIDEBAR_REGISTRY_KEY)) {
    console.warn('Sidebar registry already initialized.')
    return
  }
  setContext(SIDEBAR_REGISTRY_KEY, registry)
  return registry
}

export function getSidebarRegistry(): SidebarRegistry {
  return getContext(SIDEBAR_REGISTRY_KEY)
}

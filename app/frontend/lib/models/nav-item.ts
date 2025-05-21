import type { Snippet } from "svelte"

export type NavItem = {
    title: string
    url: string
    icon: Snippet
    badge?: string
}
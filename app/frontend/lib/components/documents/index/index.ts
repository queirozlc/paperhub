/**
 * These file are the module of all components related to the Document/Index page
 * Please, don't add new components here, add them in the appropriate file
 * Also do not use imports from anywhere else, use the index file to import them
 */

// Invitation
export { default as InvitationDialog } from './invitation-dialog.svelte'

// Documents List
export { default as DocumentsListHeader } from './list-header.svelte'
export { default as DocumentsList } from './list.svelte'
export { default as MostRecents } from './most-recents.svelte'

// Sidebar
export { default as NavFolders } from './nav-folders.svelte'
export { default as NavMain } from './nav-main.svelte'
export { default as NavSecondary } from './nav-secondary.svelte'

// Settings
export { default as ProfileSettings } from './settings/profile-settings.svelte'
export { default as SettingsDialog } from './settings/settings-dialog.svelte'

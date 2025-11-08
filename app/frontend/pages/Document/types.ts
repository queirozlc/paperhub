import type { HashableModel } from '$lib/utils'
import type { UserType } from '$pages/Users/types'

export interface DocumentType extends HashableModel {
  id: number
  title: string
  description: string
  team_id: number
  created_at: Date
  updated_at: Date
  content?: string // Base64 encoded Yjs binary state
  yjs_content?: string // Base64 encoded Yjs binary state
}

export type DocumentFormType = Omit<
  DocumentType,
  'id' | 'team_id' | 'created_at' | 'updated_at' | 'sqid'
>

export type InvitationForm = {
  email: string
  role: 'owner' | 'member' | ''
}

export interface BranchType {
  name: string
}

export interface CommitType {
  oid: string
  message: string
  author: Omit<UserType, 'active_team_id' | 'role'>
  time: Date
}

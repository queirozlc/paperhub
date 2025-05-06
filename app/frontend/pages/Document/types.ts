import type { HashableModel } from '@/lib/utils'

export interface DocumentType extends HashableModel {
  id: number
  title: string
  description: string
  team_id: number
  created_at: Date
  updated_at: Date
}

export type DocumentFormType = Omit<
  DocumentType,
  'id' | 'team_id' | 'created_at' | 'updated_at' | 'sqid'
>

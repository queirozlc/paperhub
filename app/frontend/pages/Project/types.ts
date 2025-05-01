import type { HashableModel } from '@/lib/utils'

export interface ProjectType extends HashableModel {
  id: number
  title: string
  description: string
  team_id: number
  created_at: Date
  updated_at: Date
}

export type ProjectFormType = Omit<ProjectType, 'id' | 'team_id'>

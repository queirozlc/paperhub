export interface ProjectType {
  id: number
  title: string
  description: string
  team_id: number
  created_at: Date
  updated_at: Date
}

export type ProjectFormType = Omit<ProjectType, 'id' | 'team_id'>

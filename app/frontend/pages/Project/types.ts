export interface ProjectType {
  id: number
  title: string
  description: string
  team_id: number
}

export type ProjectFormType = Omit<ProjectType, 'id' | 'team_id'>

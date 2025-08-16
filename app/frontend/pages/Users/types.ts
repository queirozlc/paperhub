export type UserType = {
  id: number
  email: string
  name: string
  avatar: string
  role: TeamRole
  active_team_id: number
}

export type UserInvitationType = {
  id: number
  email: string
  name: string
  avatar: string
  role: TeamRole
  invitation_sent_at: Date
}

export enum TeamRole {
  OWNER = 'owner',
  MEMBER = 'member',
}

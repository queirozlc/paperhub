export type TeamType = {
  id: number
  name: string
  cover: string
  owner_id: number
}

export type TeamForm = {
  name: string
  cover: File | null
}

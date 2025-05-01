export type TeamType = {
  id: number
  name: string
  cover: string
}

export type TeamForm = {
  name: string
  cover: File | null
}

import { notionistsNeutral } from '@dicebear/collection'
import { createAvatar } from '@dicebear/core'

export const defaultAvatar = (key: number = Math.random()) =>
  createAvatar(notionistsNeutral, {
    seed: key.toString(),
    lips: [
      'variant03',
      'variant08',
      'variant05',
      'variant06',
      'variant26',
      'variant28',
    ],
  }).toDataUri()

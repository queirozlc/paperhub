import { notionistsNeutral } from '@dicebear/collection'
import { createAvatar } from '@dicebear/core'
import { type ClassValue, clsx } from 'clsx'
import { twMerge } from 'tailwind-merge'

export type HashableModel = {
  sqid: string
}

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export const capitalize = (str: string) =>
  str.charAt(0).toUpperCase() + str.slice(1)

export function getOS() {
  const userAgent = window.navigator.userAgent,
    platform =
      window.navigator?.userAgentData?.platform || window.navigator.platform,
    macosPlatforms = ['macOS', 'Macintosh', 'MacIntel', 'MacPPC', 'Mac68K'],
    windowsPlatforms = ['Win32', 'Win64', 'Windows', 'WinCE'],
    iosPlatforms = ['iPhone', 'iPad', 'iPod']
  let os = null

  if (macosPlatforms.indexOf(platform) !== -1) {
    os = 'macOS'
  } else if (iosPlatforms.indexOf(platform) !== -1) {
    os = 'iOS'
  } else if (windowsPlatforms.indexOf(platform) !== -1) {
    os = 'Windows'
  } else if (/Android/.test(userAgent)) {
    os = 'Android'
  } else if (/Linux/.test(platform)) {
    os = 'Linux'
  }

  return os
}

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
  })

export function normalize(text) {
  return text
    .trim()
    .normalize('NFD') // separa caracteres com acento do caractere base
    .replace(/[\u0300-\u036f]/g, '') // remove os sinais diacríticos
    .toLowerCase()
}

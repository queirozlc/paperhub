import { cn } from '@/lib/utils'
import type { ComponentProps } from 'react'

export function Logo({ className, ...props }: ComponentProps<'img'>) {
  return (
    <>
      <img
        src='/images/logo.png'
        alt='Paperhub Logo'
        className={cn('w-36 dark:hidden', className)}
        {...props}
      />

      <img
        src='/images/logo-dark.png'
        alt='Paperhub Logo'
        className={cn('hidden w-36 dark:block', className)}
        {...props}
      />
    </>
  )
}

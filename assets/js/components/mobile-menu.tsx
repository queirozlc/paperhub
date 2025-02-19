import { cn } from '@/lib/utils'
import { Menu, X } from 'lucide-react'
import { Button } from './ui/button'

export function MobileMenu({
  open,
  setOpen
}: {
  open: boolean
  setOpen: React.Dispatch<React.SetStateAction<boolean>>
}) {
  return (
    <Button
      size={'icon'}
      variant={'outline'}
      className='rounded-full sm:hidden'
      onClick={() => setOpen(!open)}
    >
      <div className='relative size-4'>
        <Menu
          size={16}
          className={cn(
            'absolute inset-0 transition-[transform,opacity] duration-300 ease-in-out',
            {
              'rotate-0 opacity-100': !open,
              '-rotate-45 opacity-0': open
            }
          )}
        />

        <X
          size={16}
          className={cn(
            'absolute inset-0 transition-all duration-300 ease-in-out',
            {
              'rotate-45 opacity-0': !open,
              'rotate-0 opacity-100': open
            }
          )}
        />
      </div>
    </Button>
  )
}

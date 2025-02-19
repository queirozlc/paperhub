import { cn } from '@/lib/utils'
import { Link } from '@inertiajs/react'
import { Avatar, AvatarFallback, AvatarImage } from './ui/avatar'
import { ThemeSwitcher } from './ui/theme-switcher'

export type MobileNavItems = {
  label: string
  Icon: React.ElementType
  href: string
}

export function MobileNavbar({
  items,
  open
}: {
  items: MobileNavItems[]
  open: boolean
}) {
  return (
    <nav
      className={cn(
        'bg-background divide-border z-20 h-screen w-full gap-4 divide-y px-4 py-5 sm:hidden',
        {
          hidden: !open,
          'flex flex-col': open
        }
      )}
    >
      <div className='flex flex-col gap-3'>
        <div className='flex w-full items-center justify-between py-5'>
          <span className='text-base font-medium'>Lucas Queiroz</span>
          <Avatar>
            <AvatarImage sizes='20' src='https://github.com/queirozlc.png' />
            <AvatarFallback>LQ</AvatarFallback>
          </Avatar>
        </div>

        <div className='group flex h-12 items-center justify-between rounded-md px-3 ease-in-out'>
          <span className='text-muted-foreground group-hover:text-foreground text-base font-medium'>
            Theme
          </span>

          <ThemeSwitcher />
        </div>
      </div>

      <ul className='flex flex-col'>
        {items.map(({ href, Icon, label }, i) => (
          <li
            className='hover:bg-muted group flex h-12 cursor-pointer items-center justify-center rounded-md px-3 transition-colors duration-300 ease-in-out'
            key={i}
          >
            <Link
              href={href}
              className='flex grow items-center justify-between transition-colors duration-200 ease-in-out'
            >
              <span className='text-muted-foreground group-hover:text-foreground text-base font-medium'>
                {label}
              </span>
              <Icon
                size={20}
                className='group-hover:text-foreground text-muted-foreground'
              />
            </Link>
          </li>
        ))}
      </ul>
    </nav>
  )
}

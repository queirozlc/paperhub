import { MobileMenu } from '@/components/mobile-menu'
import { MobileNavbar, type MobileNavItems } from '@/components/mobile-navbar'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuTrigger
} from '@/components/ui/dropdown-menu'
import { Tabs } from '@/components/ui/tabs'
import { useTabs, type Tab } from '@/components/ui/tabs/use-tabs'
import { ThemeSwitcher } from '@/components/ui/theme-switcher'
import type { User } from '@/models/user'
import { Link, usePage } from '@inertiajs/react'
import {
  FolderOpen,
  HomeIcon,
  LogOut,
  LucideBell,
  MessageCircle,
  Settings
} from 'lucide-react'
import { useState } from 'react'

const tabs: Tab[] = [
  {
    href: '/',
    label: 'Projetos',
    Icon: FolderOpen,
    id: 'projects'
  },
  {
    href: '/',
    label: 'Chat',
    Icon: MessageCircle,
    id: 'chat'
  },
  {
    href: '/',
    label: 'Configurações',
    Icon: Settings,
    id: 'settings'
  }
]

const navItems: MobileNavItems[] = [
  {
    Icon: HomeIcon,
    href: '/',
    label: 'Home'
  },
  {
    Icon: Settings,
    href: '/settings',
    label: 'Configurações do perfil'
  },
  {
    Icon: LogOut,
    href: '/sign-out',
    label: 'Log out'
  }
]

export function HomeLayout({ children }: { children: React.ReactNode }) {
  const { tabProps } = useTabs({
    tabs,
    initialTabId: 'projects'
  })
  const {
    props: { user }
  } = usePage<{
    user: User
  }>()

  const [open, setOpen] = useState(false)

  return (
    <>
      <div className='bg-background border-b'>
        <header className='flex h-14 w-full items-center justify-between px-4 py-2'>
          <Link href='/' replace className='dark:hidden'>
            <img src={'/images/logo.png'} className='w-24 md:w-28' />
          </Link>

          <Link href='/' replace className='hidden dark:block'>
            <img src={'/images/logo-dark.png'} className='w-24 md:w-28' />
          </Link>

          <div className='flex items-center gap-2 sm:hidden'>
            {/* Notification for mobile */}
            <Button size={'icon'} variant={'outline'} className='rounded-full'>
              <LucideBell size={16} />
            </Button>
            <MobileMenu open={open} setOpen={setOpen} />
          </div>

          <div className='hidden items-center gap-2 sm:flex'>
            {/* Notification for desktop and medium devices */}
            <Button size={'icon'} variant={'outline'} className='rounded-full'>
              <LucideBell size={16} />
            </Button>

            <DropdownMenu>
              <DropdownMenuTrigger
                asChild
                className='ring-primary outline-primary-foreground cursor-pointer ring-offset-1 transition-colors duration-300 ease-linear hover:ring hover:outline-1 focus-visible:ring focus-visible:outline'
              >
                <Avatar>
                  <AvatarImage
                    sizes='20'
                    src='https://github.com/queirozlc.png'
                  />
                  <AvatarFallback>LQ</AvatarFallback>
                </Avatar>
              </DropdownMenuTrigger>

              <DropdownMenuContent className='mt-1 mr-8 w-full text-sm'>
                <div className='flex flex-col gap-1 px-2 py-4'>
                  {user.name && (
                    <span className='text-accent-foreground text-sm font-medium'>
                      {user.name}
                    </span>
                  )}

                  <span className='text-muted-foreground text-sm font-medium'>
                    {user.email}
                  </span>
                </div>

                <div className='group flex h-12 items-center justify-between rounded-md px-3 ease-in-out'>
                  <span className='text-muted-foreground group-hover:text-foreground font-medium'>
                    Tema
                  </span>

                  <ThemeSwitcher />
                </div>

                <ul className='flex flex-col'>
                  {navItems.map(({ href, Icon, label, method }, i) => (
                    <li
                      className='hover:bg-muted group flex h-12 cursor-pointer items-center justify-center rounded-md px-3 transition-colors duration-300 ease-in-out'
                      key={i}
                    >
                      <Link
                        href={href}
                        className='flex grow items-center justify-between transition-colors duration-200 ease-in-out'
                        method={method || 'get'}
                      >
                        <span className='text-muted-foreground group-hover:text-foreground font-medium'>
                          {label}
                        </span>
                        <Icon className='group-hover:text-foreground text-muted-foreground size-4' />
                      </Link>
                    </li>
                  ))}
                </ul>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </header>

        <MobileNavbar items={navItems} open={open} user={user} />

        <Tabs {...tabProps} />
      </div>

      <main className='bg-background-off dark:bg-background-off/30 relative min-h-[calc(100vh-7rem)] px-4 py-6'>
        {children}
      </main>
    </>
  )
}

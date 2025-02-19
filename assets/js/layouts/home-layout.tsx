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
import { Link } from '@inertiajs/react'
import {
  FolderOpen,
  HomeIcon,
  LogOut,
  LucideBell,
  MessageCircle,
  Settings
} from 'lucide-react'
import { useState } from 'react'

const navItems: Tab[] = [
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

const navItemsMobile: MobileNavItems[] = [
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
    href: '/logout',
    label: 'Log out'
  }
]

export function HomeLayout({ children }: { children: React.ReactNode }) {
  const { tabProps } = useTabs({
    tabs: navItems,
    initialTabId: 'projects'
  })
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

          <div className='items-cnter hidden gap-2 sm:flex'>
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

              <DropdownMenuContent></DropdownMenuContent>
            </DropdownMenu>
          </div>
        </header>

        <MobileNavbar items={navItemsMobile} open={open} />

        <Tabs {...tabProps} />
      </div>

      <main className='bg-background-off relative min-h-[calc(100vh-7rem)] px-4 py-6'>
        {children}
      </main>
    </>
  )
}

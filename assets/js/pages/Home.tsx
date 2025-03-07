import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuTrigger
} from '@/components/ui/dropdown-menu'
import { Input } from '@/components/ui/input'
import { HomeLayout } from '@/layouts/home-layout'
import { cn } from '@/lib/utils'
import type { Projects } from '@/models/project'
import { Head } from '@inertiajs/react'
import { ChevronDown, Plus, Search } from 'lucide-react'
import { useState } from 'react'

export default function Home({ projects }: { projects: Projects[] }) {
  const [projectDropDownOpen, setProjectDropDownOpen] = useState(false)

  return (
    <HomeLayout>
      <Head title='PaperHub | Projetos' />

      <section className='mx-auto flex items-center gap-3'>
        <div className='relative grow'>
          <Search
            size={20}
            className='absolute top-1/2 left-2 -translate-y-1/2'
          />
          <Input
            className='h-10 max-w-screen-sm pr-4 pl-10 text-sm'
            placeholder='Procure por algum projeto'
          />
        </div>

        <Button className='size-10 sm:hidden'>
          <Plus size={16} />
        </Button>

        <DropdownMenu
          open={projectDropDownOpen}
          onOpenChange={(value) => setProjectDropDownOpen(value)}
        >
          <DropdownMenuTrigger asChild>
            <Button
              size={'lg'}
              className='hidden items-center gap-1 rounded-md sm:flex'
            >
              Criar Novo...
              <ChevronDown
                className={cn(
                  'size-5 transition-transform duration-200 ease-in-out',
                  {
                    'rotate-180': projectDropDownOpen
                  }
                )}
              />
            </Button>
          </DropdownMenuTrigger>
        </DropdownMenu>
      </section>

      <div className='pt-10'>
        {/* Project list goes here */}
        {projects.map(({ title, id }) => (
          <div key={id}>{title}</div>
        ))}
      </div>
    </HomeLayout>
  )
}

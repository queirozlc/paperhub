import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { HomeLayout } from '@/layouts/home-layout'
import type { Projects } from '@/models/project'
import { Head, Link } from '@inertiajs/react'
import { Plus, Search } from 'lucide-react'

export default function Home({ projects }: { projects: Projects[] }) {
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

        <Link href={'/projects'} method='post'>
          <div>
            <Button className='hidden sm:block'>Novo Projeto</Button>
          </div>
        </Link>
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

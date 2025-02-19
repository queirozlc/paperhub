import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { HomeLayout } from '@/layouts/home-layout'
import { Head } from '@inertiajs/react'
import { Plus, Search } from 'lucide-react'

type Projects = {
  id: number
  title: string
  description: string
  slug: string
}

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

        <Button className='hidden sm:block'>Novo Projeto</Button>
      </section>

      <section className='flex w-full flex-col justify-center gap-3 pt-10'>
        {projects.map(({ description, id, slug, title }) => (
          <div key={id}>
            <h2 className='text-lg font-bold'>{title}</h2>
            <p className='text-sm'>{description}</p>
            <a
              href={`/projects/${slug}`}
              className='text-blue-500 hover:underline'
            >
              Ver mais
            </a>
          </div>
        ))}
      </section>
    </HomeLayout>
  )
}

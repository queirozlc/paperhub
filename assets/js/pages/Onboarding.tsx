import { Logo } from '@/components/logo'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import type { User } from '@/models/user'
import { useForm } from '@inertiajs/react'
import { ArrowRight, LoaderIcon } from 'lucide-react'
import { motion } from 'motion/react'

const placeholder = (email: string) => email.split('@')[0]

export default function Onboarding({ user }: { user: User }) {
  const { setData, data, post, processing } = useForm({
    name: ''
  })

  function submit(e: React.FormEvent) {
    e.preventDefault()
    post('/teams')
  }

  return (
    <section className='bg-background-off flex h-screen w-full items-start justify-center lg:flex-row lg:gap-10'>
      <div className='font-brand flex grow-1 flex-col justify-center space-y-10 px-6 pt-24'>
        <motion.div
          initial={{
            x: -100,
            opacity: 0,
            scale: 0.5
          }}
          animate={{
            x: 0,
            opacity: 1,
            scale: 1
          }}
          transition={{
            type: 'spring',
            stiffness: 260,
            damping: 20
          }}
        >
          <Logo className='w-32' />
        </motion.div>
        <h1 className='text-accent-foreground'>
          Vamos preparar o seu perfil 🚀
        </h1>

        <div className='space-y-2'>
          <h2 className='text-accent-foreground'>
            Queremos te conhecer melhor, qual seu nome?
          </h2>
          <p className='text-muted-foreground'>
            É assim que você será chamado por aqui
          </p>
        </div>

        <form onSubmit={submit} id='update-name'>
          <Input
            value={data.name}
            onChange={(event) => setData('name', event.target.value)}
            required
            id='name'
            className='h-12'
            placeholder={placeholder(user.email)}
          />
        </form>

        <span className='text-muted-foreground text-sm'>
          Não se preocupe, você poderá alterar isso a qualquer momento
        </span>

        <Button
          form='update-name'
          type='submit'
          className='h-12 w-full gap-2 text-lg'
          disabled={processing}
        >
          {processing ? (
            <LoaderIcon className='size-5 animate-spin' />
          ) : (
            <>
              Continuar
              <ArrowRight className='size-5' />
            </>
          )}
        </Button>
      </div>

      <div className='bg-muted shadow-[0px 0px 20px rgba(0,0,0,0.1)] border-background-off hidden h-full grow flex-col items-center justify-center border-l lg:flex'>
        <motion.img
          src='/images/reading.png'
          alt='Ilustração de uma mulher lendo um livro'
          className='max-w-md dark:hidden'
          initial={{
            x: 100,
            opacity: 0,
            scale: 0.5
          }}
          animate={{
            x: 0,
            opacity: 1,
            scale: 1
          }}
          transition={{
            type: 'spring',
            stiffness: 260,
            damping: 20
          }}
        />

        <motion.img
          src='/images/reading-dark.png'
          alt='Ilustração de uma mulher lendo um livro'
          className='hidden max-w-md dark:block'
          initial={{
            x: 100,
            opacity: 0,
            scale: 0.5
          }}
          animate={{
            x: 0,
            opacity: 1,
            scale: 1
          }}
          transition={{
            type: 'spring',
            stiffness: 260,
            damping: 20
          }}
        />

        <motion.img
          src='/images/documents.png'
          alt='Ilustração de uma mulher lendo um livro'
          className='max-w-md dark:hidden'
          initial={{
            x: 100,
            opacity: 0,
            scale: 0.5
          }}
          animate={{
            x: 0,
            opacity: 1,
            scale: 1
          }}
          transition={{
            type: 'spring',
            stiffness: 260,
            damping: 20
          }}
        />

        <motion.img
          src='/images/documents-dark.png'
          alt='Ilustração de uma mulher lendo um livro'
          className='hidden max-w-md dark:block'
          initial={{
            x: 100,
            opacity: 0,
            scale: 0.5
          }}
          animate={{
            x: 0,
            opacity: 1,
            scale: 1
          }}
          transition={{
            type: 'spring',
            stiffness: 260,
            damping: 20
          }}
        />

        <motion.img
          src='/images/scribble.svg'
          alt='Ilustração de uma mulher lendo um livro'
          className='size-24 rotate-90 rotate-x-180 dark:hidden'
          initial={{
            x: 100,
            opacity: 0,
            scale: 0.5
          }}
          animate={{
            x: 0,
            opacity: 1,
            scale: 1
          }}
          transition={{
            type: 'spring',
            stiffness: 260,
            damping: 20
          }}
        />

        <motion.img
          src='/images/scribble-dark.svg'
          alt='Ilustração de uma mulher lendo um livro'
          className='hidden size-24 -rotate-90 dark:block'
          initial={{
            x: 100,
            opacity: 0,
            scale: 0.5
          }}
          animate={{
            x: 0,
            opacity: 1,
            scale: 1
          }}
          transition={{
            type: 'spring',
            stiffness: 260,
            damping: 20
          }}
        />
      </div>
    </section>
  )
}

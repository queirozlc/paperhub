import { Logo } from '@/components/logo'
import { Button } from '@/components/ui/button'
import { Link } from '@inertiajs/react'
import { ArrowLeft, ArrowUpRight } from 'lucide-react'
import { motion } from 'motion/react'

const isGmail = (email: string) => email.endsWith('@gmail.com')

export default function VerifyEmail({ email }: { email: string }) {
  return (
    <div className='bg-background-off grid min-h-screen'>
      <section className='flex w-full justify-center px-8 py-16 md:mb-32 md:items-center'>
        <div className='space-y-6'>
          <Link href='/login' className='inline-block'>
            <motion.div
              whileTap={{
                scale: 0.95
              }}
              initial={{
                opacity: 0,
                scale: 0.5
              }}
              animate={{
                opacity: 1,
                scale: 1
              }}
              transition={{
                delay: 0.05,
                duration: 0.2,
                type: 'spring',
                stiffness: 700,
                damping: 30
              }}
              className='font-brand bg-background dark:bg-muted border-muted-foreground/10 hover:inset-shadow-md flex h-8 items-center gap-1 rounded-lg border-[.5px] px-3 text-sm font-semibold inset-shadow-sm shadow-md hover:shadow-lg'
            >
              <ArrowLeft className='size-4' />
              <span className='text-nowrap'>Voltar</span>
            </motion.div>
          </Link>
          <motion.div
            initial={{
              opacity: 0,
              scale: 0.5
            }}
            animate={{
              opacity: 1,
              scale: 1
            }}
            transition={{
              delay: 0.05,
              duration: 0.2,
              type: 'spring',
              stiffness: 700,
              damping: 30
            }}
            className='border-muted-foreground/10 bg-background dark:bg-muted shadow-card w-full max-w-lg overflow-hidden rounded-3xl border-[0.5px]'
          >
            <div className='border-muted-foreground/10 flex items-center justify-center border-b px-16 py-6'>
              <Logo className='w-32' />
            </div>

            <div className='space-y-6 p-6 text-center md:p-12'>
              <h1 className='font-brand text-2xl font-bold lg:text-3xl lg:tracking-tight'>
                Bem-vindo! Agora é só confirmar o seu e-mail 🎉
              </h1>

              <p className='text-muted-foreground/60'>
                Enviamos um e-mail para{' '}
                <span className='text-accent-foreground font-semibold'>
                  {email}
                </span>{' '}
                com um link para verificação. Clique no link para continuar.
              </p>

              {isGmail(email) && (
                <motion.a
                  // open the link in a new tab
                  target='__blank'
                  // href to the email provider to check the inbox
                  href={`https://mail.google.com/mail/u/0/#search/from%3APaperhub%20%3Chello%40resend.paperhub.app%3E`}
                  whileTap={{
                    scale: 0.95
                  }}
                  initial={{
                    opacity: 0,
                    scale: 0.5
                  }}
                  animate={{
                    opacity: 1,
                    scale: 1
                  }}
                  transition={{
                    delay: 0.05,
                    duration: 0.2,
                    type: 'spring',
                    stiffness: 700,
                    damping: 30
                  }}
                >
                  <Button
                    type='submit'
                    className='font-brand border-primary outline-primary ring-primary shadow-primary inset-shadow-primary h-12 w-full text-lg font-semibold duration-200 ease-in-out hover:ring-2 hover:shadow-[1px_1px_2px_var(--color-primary)] hover:outline-1 focus-visible:ring-2 focus-visible:outline-2'
                  >
                    Checar inbox <ArrowUpRight className='size-6' />
                  </Button>
                </motion.a>
              )}
            </div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}

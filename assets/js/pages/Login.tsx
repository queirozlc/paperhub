import { LoginForm } from '@/components/login-form'

export default function LoginPage() {
  return (
    <div className='bg-background-off grid h-screen lg:grid-cols-12'>
      <div className='border-border/40 col-span-5 h-full w-full overflow-hidden border-r shadow-[1px_0_16px_rgba(0,0,0,0.05)] brightness-90 max-lg:hidden dark:brightness-75'>
        <img
          src='/placeholder.svg'
          alt='Image'
          className='absolute inset-0 h-full w-full object-cover dark:brightness-[0.2] dark:grayscale'
        />
      </div>
      <section className='col-span-7 flex w-full flex-col items-center justify-center gap-4 px-8 py-16'>
        <div className='border-border bg-background/30 w-full max-w-lg overflow-hidden rounded-3xl border-[0.5px] p-8 shadow-[1px_1px_8px_rgba(0,0,0,0.1)]'>
          <LoginForm />
        </div>
      </section>
    </div>
  )
}

import { useTheme } from '@/lib/theme-provider'
import { motion } from 'framer-motion'
import { Monitor, Moon, Sun } from 'lucide-react'

export function ThemeSwitcher() {
  const { theme, setTheme } = useTheme()

  const handleClick = () => {
    if (theme === 'light') setTheme('dark')
    else if (theme === 'dark') setTheme('system')
    else setTheme('light')
  }

  return (
    <motion.button
      className='bg-background border-border relative flex h-8 w-24 items-center rounded-full border p-1 shadow-inner'
      onClick={handleClick}
      aria-label='Toggle theme'
      whileTap={{ scale: 0.95 }}
    >
      <motion.div
        className='bg-background absolute size-8 rounded-full border shadow-md'
        animate={{
          left:
            theme === 'light'
              ? '0px'
              : theme === 'dark'
                ? 'calc(100% - 32px)'
                : 'calc(100% - 63px)'
        }}
        transition={{
          type: 'spring',
          stiffness: 700,
          damping: 30
        }}
      />
      <motion.div
        className='flex h-full w-full items-center justify-between px-1'
        animate={{
          opacity: 1
        }}
        initial={{
          opacity: 0
        }}
      >
        <Sun className='text-muted-foreground z-10 size-4' />
        <Monitor className='text-muted-foreground z-10 size-4' />
        <Moon className='text-muted-foreground z-10 size-4' />
      </motion.div>
      <span className='sr-only'>
        {theme === 'light'
          ? 'Light Mode'
          : theme === 'dark'
            ? 'Dark Mode'
            : 'System Theme'}
      </span>
    </motion.button>
  )
}

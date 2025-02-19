import { cn } from '@/lib/utils'
import { AnimatePresence, LayoutGroup, motion } from 'motion/react'
import { useState } from 'react'

import { Link } from '@inertiajs/react'
import { type Tab } from './use-tabs'

const transition = {
  type: 'tween',
  ease: 'easeOut',
  duration: 0.15
}

type Props = {
  selectedTabIndex: number
  tabs: Tab[]
  setSelectedTab: (input: [number, number]) => void
}

export function Tabs({ tabs, selectedTabIndex, setSelectedTab }: Props) {
  const [hoveredTab, setHoveredTab] = useState<number | null>(null)
  return (
    <motion.nav
      className='no-scrollbar relative z-0 flex flex-shrink-0 items-center overflow-x-scroll py-2'
      onHoverEnd={() => setHoveredTab(null)}
    >
      <LayoutGroup id='tabs'>
        {tabs.map(({ id, href, label, Icon }, i) => {
          return (
            <Link href={href} key={id}>
              <motion.button
                className={cn(
                  'text-muted-foreground relative flex h-8 cursor-pointer items-center rounded-md px-4 text-sm transition-colors select-none',
                  {
                    'text-foreground':
                      hoveredTab === i || selectedTabIndex === i
                  }
                )}
                onHoverStart={() => setHoveredTab(i)}
                onFocus={() => setHoveredTab(i)}
                onClick={() => {
                  setSelectedTab([i, i > selectedTabIndex ? 1 : -1])
                }}
              >
                <div className='flex items-center gap-2'>
                  {Icon && <Icon className={cn('z-20 size-4')} />}
                  <span className='z-20'>{label}</span>
                </div>

                {i === selectedTabIndex ? (
                  <motion.div
                    transition={transition}
                    layoutId='underline'
                    className={
                      'bg-primary absolute right-2 -bottom-2 left-2 z-10 h-0.5'
                    }
                  />
                ) : null}
                <AnimatePresence>
                  {i === hoveredTab ? (
                    <motion.div
                      className='bg-accent absolute top-0 right-0 bottom-0 left-0 z-10 rounded-md'
                      initial={{
                        opacity: 0
                      }}
                      animate={{
                        opacity: 1
                      }}
                      exit={{
                        opacity: 0
                      }}
                      transition={transition}
                      layoutId='hover'
                    />
                  ) : null}
                </AnimatePresence>
              </motion.button>
            </Link>
          )
        })}
      </LayoutGroup>
    </motion.nav>
  )
}

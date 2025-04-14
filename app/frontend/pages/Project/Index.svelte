<script lang="ts" module>
  import {
    AudioWaveform,
    Blocks,
    Calendar,
    Command,
    MessageCircleQuestion,
    Settings2,
    Sparkles,
    Trash2,
  } from '@lucide/svelte'

  import {
    Home05 as Home,
    Inbox01 as Inbox,
    SearchSm as Search,
  } from '@voolt_technologies/untitledui-svelte'

  // This is sample data.
  const data = {
    teams: [
      {
        name: 'Acme Inc',
        logo: Command,
        plan: 'Enterprise',
      },
      {
        name: 'Acme Corp.',
        logo: AudioWaveform,
        plan: 'Startup',
      },
      {
        name: 'Evil Corp.',
        logo: Command,
        plan: 'Free',
      },
    ],
    navMain: [
      {
        title: 'Pesquisar',
        url: '#',
        icon: Search,
        tooltip:
          'Pesquise em todos os seus projetos por títulos, pastas, conteúdos e mais',
      },

      {
        title: 'Pergunte ao Turing ✨',
        url: '#',
        icon: Sparkles,
      },
      {
        title: 'Página inicial',
        url: '#',
        icon: Home,
        isActive: true,
      },
      {
        title: 'Inbox',
        url: '#',
        icon: Inbox,
        badge: '10',
      },
    ],
    navSecondary: [
      {
        title: 'Calendar',
        url: '#',
        icon: Calendar,
      },
      {
        title: 'Settings',
        url: '#',
        icon: Settings2,
      },
      {
        title: 'Templates',
        url: '#',
        icon: Blocks,
      },
      {
        title: 'Trash',
        url: '#',
        icon: Trash2,
      },
      {
        title: 'Help',
        url: '#',
        icon: MessageCircleQuestion,
      },
    ],
    favorites: [
      {
        name: 'Project Management & Task Tracking',
        url: '#',
        emoji: '📊',
      },
      {
        name: 'Family Recipe Collection & Meal Planning',
        url: '#',
        emoji: '🍳',
      },
      {
        name: 'Fitness Tracker & Workout Routines',
        url: '#',
        emoji: '💪',
      },
      {
        name: 'Book Notes & Reading List',
        url: '#',
        emoji: '📚',
      },
      {
        name: 'Sustainable Gardening Tips & Plant Care',
        url: '#',
        emoji: '🌱',
      },
      {
        name: 'Language Learning Progress & Resources',
        url: '#',
        emoji: '🗣️',
      },
      {
        name: 'Home Renovation Ideas & Budget Tracker',
        url: '#',
        emoji: '🏠',
      },
      {
        name: 'Personal Finance & Investment Portfolio',
        url: '#',
        emoji: '💰',
      },
      {
        name: 'Movie & TV Show Watchlist with Reviews',
        url: '#',
        emoji: '🎬',
      },
      {
        name: 'Daily Habit Tracker & Goal Setting',
        url: '#',
        emoji: '✅',
      },
    ],
    workspaces: [
      {
        name: 'Personal Life Management',
        emoji: '🏠',
        pages: [
          {
            name: 'Daily Journal & Reflection',
            url: '#',
            emoji: '📔',
          },
          {
            name: 'Health & Wellness Tracker',
            url: '#',
            emoji: '🍏',
          },
          {
            name: 'Personal Growth & Learning Goals',
            url: '#',
            emoji: '🌟',
          },
        ],
      },
      {
        name: 'Professional Development',
        emoji: '💼',
        pages: [
          {
            name: 'Career Objectives & Milestones',
            url: '#',
            emoji: '🎯',
          },
          {
            name: 'Skill Acquisition & Training Log',
            url: '#',
            emoji: '🧠',
          },
          {
            name: 'Networking Contacts & Events',
            url: '#',
            emoji: '🤝',
          },
        ],
      },
      {
        name: 'Creative Projects',
        emoji: '🎨',
        pages: [
          {
            name: 'Writing Ideas & Story Outlines',
            url: '#',
            emoji: '✍️',
          },
          {
            name: 'Art & Design Portfolio',
            url: '#',
            emoji: '🖼️',
          },
          {
            name: 'Music Composition & Practice Log',
            url: '#',
            emoji: '🎵',
          },
        ],
      },
      {
        name: 'Home Management',
        emoji: '🏡',
        pages: [
          {
            name: 'Household Budget & Expense Tracking',
            url: '#',
            emoji: '💰',
          },
          {
            name: 'Home Maintenance Schedule & Tasks',
            url: '#',
            emoji: '🔧',
          },
          {
            name: 'Family Calendar & Event Planning',
            url: '#',
            emoji: '📅',
          },
        ],
      },
      {
        name: 'Travel & Adventure',
        emoji: '🧳',
        pages: [
          {
            name: 'Trip Planning & Itineraries',
            url: '#',
            emoji: '🗺️',
          },
          {
            name: 'Travel Bucket List & Inspiration',
            url: '#',
            emoji: '🌎',
          },
          {
            name: 'Travel Journal & Photo Gallery',
            url: '#',
            emoji: '📸',
          },
        ],
      },
    ],
  }
</script>

<script lang="ts">
  import * as Sidebar from '@/lib/components/ui/sidebar'

  import NavFavorites from '@/lib/components/nav-favorites.svelte'
  import NavMain from '@/lib/components/nav-main.svelte'
  import NavSecondary from '@/lib/components/nav-secondary.svelte'
  import NavWorkspaces from '@/lib/components/nav-workspaces.svelte'
  import TeamSwitcher from '@/lib/components/team-switcher.svelte'
  import Button from '@/lib/components/ui/button/button.svelte'
  import { Icons } from '@/lib/components/ui/icons'
  import Separator from '@/lib/components/ui/separator/separator.svelte'
  import type { ComponentProps } from 'svelte'
  import type { TeamType } from '../Team/types'
  import type { ProjectType } from './types'

  type Props = {
    projects: ProjectType[]
    teams: TeamType[]
    flash?: { notice?: string }
  } & ComponentProps<typeof Sidebar.Root>

  let {
    projects,
    teams,
    flash,
    ref = $bindable(null),
    ...restProps
  }: Props = $props()
</script>

<svelte:head>
  <title>Home | Seus Projetos</title>
  <meta
    name="description"
    content="Seus Projetos - Dashboard de gerenciamento de projetos"
  />
</svelte:head>

<Sidebar.Provider>
  <Sidebar.Root bind:ref {...restProps}>
    <Sidebar.Header>
      <TeamSwitcher teams={data.teams} />
      <NavMain items={data.navMain} />
    </Sidebar.Header>
    <Sidebar.Content>
      <NavFavorites favorites={data.favorites} />
      <NavWorkspaces workspaces={data.workspaces} />
      <NavSecondary items={data.navSecondary} class="mt-auto" />
    </Sidebar.Content>
    <Sidebar.Rail />
  </Sidebar.Root>

  <Sidebar.Inset>
    <header class="flex h-14 items-center px-4 justify-between">
      <div class="flex items-center gap-2">
        <Sidebar.Trigger />
        <Separator orientation="vertical" class="mr-2 h-4" />
        <Button class="gap-2 h-7 shadow-xs" variant="outline" size="sm">
          <Icons.Filter class="[&>path]:fill-accent-foreground" />
          <span>Filtrar</span>
        </Button>
      </div>
      <div class="px-3 bg-red-500">a</div>
      <div class="px-3 bg-green-500">b</div>
    </header>
    <div class="flex flex-1 flex-col gap-4 px-4 py-10">
      <div class="bg-muted/50 mx-auto h-24 w-full max-w-3xl rounded-xl"></div>
      <div class="bg-muted/50 mx-auto h-full w-full max-w-3xl rounded-xl"></div>
    </div>
  </Sidebar.Inset>
</Sidebar.Provider>

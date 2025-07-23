<script lang="ts">
  import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogTitle,
    DialogTrigger,
  } from '$lib/components/ui/dialog'
  import {
    Sidebar,
    SidebarContent,
    SidebarGroup,
    SidebarGroupContent,
    SidebarGroupLabel,
    SidebarHeader,
    SidebarMenu,
    SidebarMenuButton,
    SidebarMenuItem,
    SidebarProvider,
  } from '$lib/components/ui/sidebar'
  import {
    ChevronDown,
    CircleArrowUp,
    CreditCard,
    Icon,
    Paintbrush,
    Settings2,
    Users,
  } from '@lucide/svelte'
  import {
    Breadcrumb,
    BreadcrumbItem,
    BreadcrumbLink,
    BreadcrumbList,
    BreadcrumbPage,
    BreadcrumbSeparator,
  } from '$lib/components/ui/breadcrumb'
  import type { NavSecondaryItem } from '$layouts/HomeLayout.svelte'
  import { type ComponentProps } from 'svelte'
  import ProfileSettings from './profile-settings.svelte'
  import {
    SettingsDialogInset,
    SettingsDialogInsetHeader,
  } from '$lib/components/ui/settings-dialog'
  import ProfileSettingsContent from './profile-settings-content.svelte'
  import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuTrigger,
  } from '$lib/components/ui/dropdown-menu'
  import { cn } from '$lib/utils'

  type GroupItem = {
    slug: string
    label: string
    icon: typeof Icon
    isActive?: boolean
    tooltip?: string
  }

  type Group = {
    title: string
    items: GroupItem[]
  }

  type Props = {
    open: boolean
    item: NavSecondaryItem
    triggerProps: ComponentProps<typeof SidebarMenuButton>
  }

  let groups: Group[] = $state<Group[]>([
    {
      title: 'Gerais',
      items: [
        {
          slug: 'appearence',
          label: 'Aparência',
          icon: Paintbrush,
          isActive: false,
          tooltip: 'Altere temas, cores e outras configurações visuais',
        },
        {
          slug: 'payments',
          label: 'Pagamentos',
          icon: CreditCard,
          isActive: false,
          tooltip: 'Gerencie suas assinaturas e pagamentos',
        },
        {
          slug: 'plans',
          label: 'Planos',
          icon: CircleArrowUp,
          isActive: false,
          tooltip: 'Gerencie seus planos e assinaturas',
        },
      ],
    },
    {
      title: 'Workspace',
      items: [
        {
          slug: 'preferences',
          label: 'Preferências',
          icon: Settings2,
          isActive: false,
          tooltip: 'Gerencie suas preferências de workspace',
        },
        {
          slug: 'members',
          label: 'Membros',
          icon: Users,
          isActive: false,
          tooltip: 'Gerencie seus membros e permissões',
        },
      ],
    },
  ])

  let activeItem = $state<GroupItem>(null!)
  let profileView = $state(true)
  let { open = $bindable(false), item, triggerProps }: Props = $props()

  function setActiveMenu(groupIndex: number, itemIndex: number) {
    groups = groups.map((group) => ({
      ...group,
      items: group.items.map((item) => ({
        ...item,
        isActive: false,
      })),
    }))

    groups[groupIndex].items[itemIndex].isActive = true
    activeItem = groups[groupIndex].items[itemIndex]
    profileView = false
  }

  const menuOptionsContent = {
    appearence: appearenceContent,
    payments: paymentsContent,
    plans: plansContent,
    preferences: preferencesContent,
    members: membersContent,
  }

  function setProfileView() {
    groups = groups.map((group) => ({
      ...group,
      items: group.items.map((item) => ({
        ...item,
        isActive: false,
      })),
    }))

    activeItem = null
    profileView = true
  }
</script>

{#snippet appearenceContent(item: GroupItem)}
  <div>
    <h1>{item.label}</h1>
  </div>
{/snippet}

{#snippet paymentsContent(item: GroupItem)}
  <div>
    <h1>{item.label}</h1>
  </div>
{/snippet}

{#snippet plansContent(item: GroupItem)}
  <div>
    <h1>{item.label}</h1>
  </div>
{/snippet}

{#snippet preferencesContent(item: GroupItem)}
  <div>
    <h1>{item.label}</h1>
  </div>
{/snippet}

{#snippet membersContent(item: GroupItem)}
  <div>
    <h1>{item.label}</h1>
  </div>
{/snippet}

<Dialog bind:open>
  <DialogTrigger>
    {#snippet child({ props })}
      <button {...triggerProps} {...props}>
        <item.icon class="stroke-[2.5]" />
        <span>{item.title}</span>
      </button>
    {/snippet}
  </DialogTrigger>
  <DialogContent
    class="overflow-hidden p-0 md:max-h-[700px] md:max-w-[700px] lg:max-w-[1000px]"
    trapFocus={false}
  >
    <DialogTitle class="sr-only">Settings</DialogTitle>
    <DialogDescription class="sr-only"
      >Customize your settings here.</DialogDescription
    >
    <SidebarProvider class="items-start" name="settings">
      <Sidebar class="hidden md:flex" collapsible="none">
        <SidebarHeader class="px-4 py-3">
          <h4 class="text-lg font-semibold">Configurações</h4>
        </SidebarHeader>
        <SidebarContent>
          <ProfileSettings
            isActive={profileView}
            onProfileClick={() => setProfileView()}
          />

          {#each groups as group, groupIndex (group.title)}
            <SidebarGroup>
              <SidebarGroupLabel class="font-semibold"
                >{group.title}</SidebarGroupLabel
              >
              <SidebarGroupContent>
                <SidebarMenu>
                  {#each group.items as item, itemIndex (item.label)}
                    <SidebarMenuItem>
                      <SidebarMenuButton
                        onclick={() => setActiveMenu(groupIndex, itemIndex)}
                        tooltipContentProps={{
                          class: 'bg-tooltip',
                        }}
                        class="[&>svg]:size-4"
                        isActive={item.isActive}
                      >
                        {#snippet tooltipContent()}
                          {item.tooltip}
                        {/snippet}
                        <item.icon class="stroke-2" />
                        <span
                          class="text-sm font-medium text-sidebar-accent-foreground"
                          >{item.label}</span
                        >
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                  {/each}
                </SidebarMenu>
              </SidebarGroupContent>
            </SidebarGroup>
          {/each}
        </SidebarContent>
      </Sidebar>
      <SettingsDialogInset>
        <SettingsDialogInsetHeader>
          <div class="flex items-center gap-2 px-4">
            <Breadcrumb>
              <BreadcrumbList>
                <BreadcrumbItem class="hidden md:block">
                  <BreadcrumbLink>
                    {#snippet child({ props })}
                      <span {...props}> Configurações </span>
                    {/snippet}
                  </BreadcrumbLink>
                </BreadcrumbItem>
                {#if profileView}
                  <BreadcrumbSeparator class="hidden md:block" />
                  <BreadcrumbItem>
                    <BreadcrumbPage>Perfil</BreadcrumbPage>
                  </BreadcrumbItem>
                {:else if activeItem}
                  <BreadcrumbSeparator class="hidden md:block" />
                  {#each groups as group, groupIndex (group.title)}
                    {#if group.items.find(({ slug }) => slug === activeItem.slug)}
                      <BreadcrumbItem class="hidden md:block">
                        <DropdownMenu>
                          <DropdownMenuTrigger
                            class="flex cursor-pointer items-center gap-1 hover:text-foreground transition-colors"
                          >
                            <span>{group.title}</span>
                            <ChevronDown class="size-4" />
                          </DropdownMenuTrigger>
                          <DropdownMenuContent
                            align="start"
                            class="min-w-[160px]"
                          >
                            {#each group.items as item (item.slug)}
                              <DropdownMenuItem
                                class={cn(
                                  'flex items-center gap-2 px-2 py-2 text-sm cursor-pointer',
                                  item.slug === activeItem.slug &&
                                    'bg-accent text-accent-foreground font-semibold'
                                )}
                                onclick={() =>
                                  setActiveMenu(
                                    groupIndex,
                                    group.items.findIndex(
                                      (i) => i.slug === item.slug
                                    )
                                  )}
                                aria-selected={item.slug === activeItem.slug}
                              >
                                {#if item.icon}
                                  <item.icon class="stroke-2 w-4 h-4" />
                                {/if}
                                <span>{item.label}</span>
                              </DropdownMenuItem>
                            {/each}
                          </DropdownMenuContent>
                        </DropdownMenu>
                      </BreadcrumbItem>
                      <BreadcrumbSeparator class="hidden md:block" />
                      <BreadcrumbItem>
                        <BreadcrumbPage>{activeItem.label}</BreadcrumbPage>
                      </BreadcrumbItem>
                    {/if}
                  {/each}
                {/if}
              </BreadcrumbList>
            </Breadcrumb>
          </div>
        </SettingsDialogInsetHeader>
        <div class="flex flex-1 flex-col gap-4 overflow-y-auto py-4 px-8 pt-0">
          {#if activeItem && !profileView}
            {@render menuOptionsContent[activeItem.slug](activeItem)}
          {:else}
            <ProfileSettingsContent />
          {/if}
        </div>
      </SettingsDialogInset>
    </SidebarProvider>
  </DialogContent>
</Dialog>

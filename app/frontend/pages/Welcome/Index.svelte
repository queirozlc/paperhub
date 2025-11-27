<script lang="ts" module>
  import welcome from '$assets/images/documents.png'
  import welcomeDark from '$assets/images/documents-dark.png'
  import sendingImage from '$assets/images/sending.svg'
  import sendingImageDark from '$assets/images/sending-dark.svg'

  import handShakeIcon from '$assets/images/handshake.svg'
  import handShakeIconDark from '$assets/images/handshake-dark.svg'
  import codeFlowIcon from '$assets/images/code-flows.svg'
  import codeFlowIconDark from '$assets/images/code-flows-dark.svg'
  import offlineIcon from '$assets/images/cloud-slash.svg'
  import offlineIconDark from '$assets/images/cloud-slash-dark.svg'
  import bookOpen from '$assets/images/book-open.svg'
  import bookOpenDark from '$assets/images/book-open-dark.svg'
  import heartIcon from '$assets/images/heart-in-hand.svg'
  import heartIconDark from '$assets/images/heart-in-hand-dark.svg'
  import avatarFemale01 from '$assets/images/avatar-female-01.svg'
  import avatarFemale01Dark from '$assets/images/avatar-female-01-dark.svg'
  import avatarFemale02 from '$assets/images/avatar-female-02.svg'
  import avatarFemale02Dark from '$assets/images/avatar-female-02-dark.svg'
  import avatarMale01 from '$assets/images/avatar-male-01.svg'
  import avatarMale01Dark from '$assets/images/avatar-male-01-dark.svg'
  import avatarMale02 from '$assets/images/avatar-male-02.svg'
  import avatarMale02Dark from '$assets/images/avatar-male-02-dark.svg'
  import starFill from '$assets/images/star-fill.svg'
  import starFillDark from '$assets/images/star-fill-dark.svg'
  import starHalfFilled from '$assets/images/star-half-filled.svg'
  import starHalfFilledDark from '$assets/images/star-half-filled-dark.svg'
  import starEmpty from '$assets/images/star.svg'
  import starEmptyDark from '$assets/images/star-dark.svg'
  import piggyBankIcon from '$assets/images/piggy-bank.svg'
  import piggyBankIconDark from '$assets/images/piggy-bank-dark.svg'
  import handsHeartIcon from '$assets/images/hands-heart.svg'
  import handsHeartIconDark from '$assets/images/hands-heart-dark.svg'
  import searchingIcon from '$assets/images/searching.svg'
  import searchingIconDark from '$assets/images/searching-dark.svg'
  import flaskRoundIcon from '$assets/images/flask-round-potion.svg'
  import flaskRoundIconDark from '$assets/images/flask-round-potion-dark.svg'
  import rocketIcon from '$assets/images/rocket.svg'
  import rocketIconDark from '$assets/images/rocket-dark.svg'
</script>

<script lang="ts">
  import { Logo } from '$lib/components/shared'
  import Button from '$lib/components/ui/button/button.svelte'
  import { Sheet, SheetContent, SheetTrigger } from '$lib/components/ui/sheet'
  import {
    Card,
    CardHeader,
    CardTitle,
    CardDescription,
    CardContent,
    CardFooter,
  } from '$lib/components/ui/card'
  import { Link } from '@inertiajs/svelte'
  import { Menu, Check } from '@lucide/svelte'
  import { ArrowUpRight } from '@voolt_technologies/untitledui-svelte'

  let mobileMenuOpen = $state(false)

  const navItems = [
    { label: 'Início', href: '#home' },
    { label: 'Por que o Paperhub?', href: '#why-paperhub' },
    { label: 'Depoimentos', href: '#testimonials' },
    { label: 'Planos', href: '#plans' },
  ]

  const whyPaperhubItems = [
    {
      label: 'Referências',
      description:
        'O Paperhub valida tudo antes. Seu trabalho merece fontes reais, não citações imaginárias.',
      image: bookOpen,
      imageDark: bookOpenDark,
      imageAlt: 'Icone de um livro aberto',
    },
    {
      label: 'Adeus caos de versões',
      description:
        'Nada de arquivo ‘FINAL’, ‘FINAL_MESMO’ e ‘AGORA_VAI’. Cada alteração tem histórico claro e auditável.',
      image: codeFlowIcon,
      imageDark: codeFlowIconDark,
      imageAlt: 'Icone de um fluxo de código',
    },
    {
      label: 'Colaboração em tempo real',
      description:
        'Trabalhe em equipe sem perder o foco. Revise juntos, corrija em tempo real e mantenha tudo sincronizado.',
      image: handShakeIcon,
      imageDark: handShakeIconDark,
      imageAlt: 'Icone de um handshake',
    },
    {
      label: 'Edite offline, sincronize depois',
      description:
        'Escreva normalmente, avance no seu texto e deixe que a sincronização automática faça a mágica depois. Sem medo de perder nada',
      image: offlineIcon,
      imageDark: offlineIconDark,
      imageAlt: 'Icone de um dispositivo offline',
    },
  ]

  const testimonials = [
    {
      description:
        'Simplesmente uma ferramenta perfeita pra auxiliar no meu futuro tcc e até mesmo nos trabalhos acadêmicos da faculdade.',
      image: avatarFemale01,
      imageDark: avatarFemale01Dark,
      imageAlt: 'Icone de um usuário',
      rating: 5,
    },
    {
      description: 'Melhor plataforma para criar documentos com parceiros',
      image: avatarFemale02,
      imageDark: avatarFemale02Dark,
      imageAlt: 'Icone de um usuário',
      rating: 5,
    },
    {
      description:
        'O versionamento do documento provavelmente é a parte que mais me deixou interessado. Isso vai ser muito bom principalmente quando se tornar colaborativo para mesclar as partes do documento de cada colaborador.',
      image: avatarMale01,
      imageDark: avatarMale01Dark,
      imageAlt: 'Icone de um usuário masculino',
      rating: 4.5,
    },
    {
      description:
        'Gostei da opção das sugestões da IA, é legal ela mostrar as dicas e destacar o ponto onde fez a sugestão. Também achei bem prática a parte dos atalhos e a facilidade pra fazer edições mais simples.',
      image: avatarMale02,
      imageDark: avatarMale02Dark,
      imageAlt: 'Icone de um usuário masculino',
      rating: 4.5,
    },
  ]

  const plans = [
    {
      title: 'Calouro',
      description:
        'Para você que está começando agora. Pague somente pelo que usar.',
      price: 'R$ 0,00 / mês',
      actualPrice: 'Pague por uso 💸',
      icon: searchingIcon,
      iconDark: searchingIconDark,
      iconAlt: 'Icone de pesquisa',
      bestChoice: false,
      features: [
        '50 créditos de IA iniciais',
        'Até 2 times',
        'Até 3 membros por time',
        'Exportações DOCX (máx 3 por mês)',
        'Edição Offline e Colaboração em Tempo Real',
        'Suporte limitado',
      ],
      cta: 'Quero só explorar',
      href: '/users/sign_in',
    },
    {
      title: 'Mestre',
      description: 'Para quem quer escrever sério… sem complicar a vida.',
      price: 'R$ 19,90 / mês',
      actualPrice: 'R$ 00,00 / mês',
      icon: flaskRoundIcon,
      iconDark: flaskRoundIconDark,
      iconAlt: 'Icone de um frasco de poção',
      bestChoice: true,
      features: [
        '1000 créditos de IA por mês',
        '7 dias de teste grátis',
        'Times ilimitados',
        'Até 10 membros por time',
        'Exportações DOCX ilimitadas',
        'Suporte dedicado',
      ],
      cta: 'Fazer um teste grátis',
      href: '/users/sign_in',
    },
    {
      title: 'Doutor',
      description: 'Para quem convive mais com documentos do que com pessoas.',
      price: 'R$ 39,90 / mês',
      actualPrice: 'R$ 00,00 / mês',
      icon: rocketIcon,
      iconDark: rocketIconDark,
      iconAlt: 'Icone de um foguete',
      bestChoice: false,
      features: [
        'Tudo do Plano Mestre',
        '200 mil créditos de IA por mês',
        'Desconto em compra de mais créditos',
        'Acesso prévio a novas funcionalidades',
        'Suporte Premium',
      ],
      cta: 'Sou um profissional',
      href: '/users/sign_in',
    },
  ]

  type StarType = 'filled' | 'half-filled' | 'empty'

  function getStars(rating: number): StarType[] {
    const stars: StarType[] = []
    const maxStars = 5
    const fullStars = Math.floor(rating)
    const hasHalfStar = rating % 1 >= 0.5

    for (let i = 0; i < maxStars; i++) {
      if (i < fullStars) {
        stars.push('filled')
      } else if (i === fullStars && hasHalfStar) {
        stars.push('half-filled')
      } else {
        stars.push('empty')
      }
    }

    return stars
  }
</script>

<header
  class="fixed top-0 left-0 right-0 z-50 bg-background-off backdrop-blur supports-[backdrop-filter]:bg-background-off"
>
  <nav class="container mx-auto px-4 lg:px-8">
    <div class="flex h-16 items-center justify-between">
      <a href="/" class="text-foreground hover:opacity-80 transition-opacity">
        <Logo class="w-28" />
      </a>

      <!-- Desktop Navigation -->
      <div class="hidden md:flex items-center gap-8">
        {#each navItems as item, index (index)}
          <a
            href={item.href}
            class="text-sm font-medium text-muted-foreground hover:text-accent-foreground transition-colors"
            onclick={(e) => {
              e.preventDefault()
              const element = document.querySelector(item.href)
              if (element) {
                element.scrollIntoView({
                  behavior: 'smooth',
                })
              }
            }}
          >
            {item.label}
          </a>
        {/each}
      </div>

      <div class="hidden md:flex items-center gap-4">
        <Link href="/users/sign_in"
          ><Button class="font-brand h-9 md:text-base lg:text-lg font-semibold">
            Começar agora
          </Button></Link
        >
      </div>

      <!-- Mobile Navigation -->
      <Sheet bind:open={mobileMenuOpen}>
        <SheetTrigger class="md:hidden">
          <Button variant="ghost" size="icon">
            <Menu class="size-5" />
          </Button>
        </SheetTrigger>
        <SheetContent side="top" class="w-full h-full flex flex-col x-0">
          <div class="flex flex-col gap-6 mt-8">
            {#each navItems as item, index (index)}
              <a
                href={item.href}
                class="text-lg px-6 font-medium text-foreground hover:text-accent transition-colors"
                onclick={(e) => {
                  e.preventDefault()
                  const element = document.querySelector(item.href)
                  if (element) {
                    element.scrollIntoView({
                      behavior: 'smooth',
                      inline: 'start',
                    })
                  }

                  mobileMenuOpen = false
                }}
              >
                {item.label}
              </a>
            {/each}
          </div>

          <div class="px-2 flex grow pb-10">
            <Button
              class="font-brand h-12 w-full text-lg self-end font-semibold"
            >
              <Link href="/users/sign_in">Começar agora</Link>
            </Button>
          </div>
        </SheetContent>
      </Sheet>
    </div>
  </nav>
</header>

<main class="bg-background-off relative min-h-screen flex items-center pt-16">
  <div class="container mx-auto px-4 lg:px-8 py-20">
    <!-- Hero Section -->
    <div class="space-y-8 slide-in-from-bottom">
      <section
        class="grid relative lg:grid-cols-2 gap-12 items-center scroll-m-20 lg:scroll-m-10"
        id="home"
      >
        <div class="space-y-4">
          <h1 class="font-brand text-4xl font-bold">
            Seu Projeto Acadêmico não precisa ser tão sofrido assim 🤯
          </h1>
          <p class="text-lg font-brand">
            O Paperhub é um editor moderno que organiza o caos da escrita:
            versionamento automático, referências confiáveis e uma IA que
            trabalha a seu favor — não contra você: <strong
              class="relative before:w-full before:-skew-y-3 before:h-0.5 before:bg-primary before:absolute before:bottom-0 before:left-0"
              >simples
            </strong>,
            <span
              class="relative pointer-events-none inline-block before:absolute before:-inset-1 before:block before:-skew-y-3 before:bg-primary"
            >
              <span class="font-bold relative z-10 dark:text-primary-foreground"
                >eficiente</span
              >
            </span>
            e <strong>sem sofrimento.</strong>
          </p>

          <Link href="/users/sign_in">
            <Button
              class="font-brand h-12 w-full text-base md:text-lg font-semibold"
            >
              Quero experimentar agora
              <ArrowUpRight class="size-5" />
            </Button>
          </Link>
        </div>
        <div class="flex justify-center">
          <img
            src={welcome}
            alt="Welcome"
            class="w-full max-w-md object-cover dark:hidden"
          />
          <img
            src={welcomeDark}
            alt="Welcome Dark"
            class="w-full max-w-md object-cover hidden dark:block"
          />
        </div>
      </section>

      <!-- Why Paperhub Section -->

      <section
        class="grid relative lg:grid-cols-2 gap-12 items-center py-10 scroll-m-20 lg:scroll-m-10"
        id="why-paperhub"
      >
        <div class="pt-8 hidden lg:block">
          <img
            src={sendingImage}
            alt="Sending"
            class="w-full max-w-md object-cover mx-auto dark:hidden"
          />
          <img
            src={sendingImageDark}
            alt="Sending Dark"
            class="w-full max-w-md object-cover mx-auto hidden dark:block"
          />
        </div>

        <div class="space-y-6">
          <h2 class="font-brand font-bold">Por que o Paperhub?</h2>

          <div class="grid lg:grid-cols-2 gap-6 lg:grid-rows-2">
            {#each whyPaperhubItems as item, index (index)}
              <div class="flex flex-col gap-8">
                <img
                  src={item.image}
                  alt={item.imageAlt}
                  class="size-10 dark:hidden"
                />
                <img
                  src={item.imageDark}
                  alt={item.imageAlt}
                  class="size-10 hidden dark:block"
                />

                <div class="space-y-2">
                  <h3 class="font-brand text-xl font-bold">
                    {item.label}
                  </h3>
                  <p class="text-accent-foreground font-medium">
                    {item.description}
                  </p>
                </div>
              </div>
            {/each}
          </div>
        </div>

        <div class="pt-8 lg:hidden">
          <img
            src={sendingImage}
            alt="Sending"
            class="w-full max-w-md object-cover mx-auto dark:hidden"
          />
          <img
            src={sendingImageDark}
            alt="Sending Dark"
            class="w-full max-w-md object-cover mx-auto hidden dark:block"
          />
        </div>
      </section>

      <!-- Testimonials Section -->
      <section
        class="relative flex flex-col gap-12 py-10 scroll-m-20 lg:scroll-m-10"
        id="testimonials"
      >
        <div class="space-y-6">
          <div class="flex items-center gap-2">
            <h2 class="font-brand text-xl md:text-3xl font-bold">
              O que nossos usuários estão dizendo
            </h2>
            <img src={heartIcon} alt="Heart" class="size-8 dark:hidden" />
            <img
              src={heartIconDark}
              alt="Heart Dark"
              class="size-8 hidden dark:block"
            />
          </div>
          <p class="text-accent-foreground font-medium">
            Veja alguns feedbacks que tivemos
          </p>
        </div>

        <div class="grid lg:grid-cols-2 gap-6 lg:grid-rows-2">
          {#each testimonials as item, index (index)}
            <div class="flex flex-col gap-4">
              <p class="text-accent-foreground font-medium text-lg italic">
                &ldquo;{item.description}&rdquo;
              </p>

              <div class="flex items-center gap-4">
                <img
                  src={item.image}
                  alt={item.imageAlt}
                  class="size-10 dark:hidden"
                />
                <img
                  src={item.imageDark}
                  alt={item.imageAlt}
                  class="size-10 hidden dark:block"
                />

                <div class="flex items-center gap-1">
                  {#each getStars(item.rating) as starType, index (index)}
                    {#if starType === 'filled'}
                      <img
                        src={starFill}
                        alt="Filled star"
                        class="size-4 dark:hidden"
                      />
                      <img
                        src={starFillDark}
                        alt="Filled star"
                        class="size-4 hidden dark:block"
                      />
                    {:else if starType === 'half-filled'}
                      <img
                        src={starHalfFilled}
                        alt="Half-filled star"
                        class="size-4 dark:hidden"
                      />
                      <img
                        src={starHalfFilledDark}
                        alt="Half-filled star"
                        class="size-4 hidden dark:block"
                      />
                    {:else}
                      <img
                        src={starEmpty}
                        alt="Empty star"
                        class="size-4 dark:hidden"
                      />
                      <img
                        src={starEmptyDark}
                        alt="Empty star"
                        class="size-4 hidden dark:block"
                      />
                    {/if}
                  {/each}
                </div>
              </div>
            </div>
          {/each}
        </div>
      </section>

      <!-- Plans Section -->
      <section
        class="relative flex flex-col gap-12 py-10 scroll-m-20 lg:scroll-m-10"
        id="plans"
      >
        <div class="flex flex-col gap-6 items-center">
          <div class="flex items-center gap-2">
            <h2 class="font-brand text-xl md:text-3xl font-bold">
              O patrão ficou maluco!!!
            </h2>

            <img
              src={piggyBankIcon}
              alt="Piggy Bank"
              class="size-10 dark:hidden"
            />
            <img
              src={piggyBankIconDark}
              alt="Piggy Bank Dark"
              class="size-10 hidden dark:block"
            />
          </div>
          <p class="text-accent-foreground font-medium">
            Como estamos em fase beta, aqueles que acreditarem em nós e quiserem
            ajudar a melhorar o produto, podem usar as funcionalidades de graça
            por tempo <span
              class="relative mt-2 inline-block before:absolute before:-inset-1 before:block before:-skew-y-3 before:bg-primary"
            >
              <span class="font-bold relative z-10 dark:text-primary-foreground"
                >limitado</span
              >
            </span>
          </p>

          <div class="grid lg:grid-cols-3 gap-6 w-full">
            {#each plans as plan, index (index)}
              <Card
                class={plan.bestChoice
                  ? 'border-primary border-2 relative'
                  : ''}
              >
                {#if plan.bestChoice}
                  <div
                    class="absolute -top-3 left-1/2 -translate-x-1/2 bg-primary text-primary-foreground px-3 py-1 rounded-full text-xs font-semibold"
                  >
                    Mais Popular
                  </div>
                {/if}
                <CardHeader class="pt-8 gap-4 flex flex-col items-center">
                  <img
                    src={plan.icon}
                    alt={plan.iconAlt}
                    class="size-10 dark:hidden"
                  />
                  <img
                    src={plan.iconDark}
                    alt={plan.iconAlt}
                    class="size-10 hidden dark:block"
                  />
                  <CardTitle class="text-2xl w-fit font-brand">
                    <p
                      class="relative before:block before:w-full before:-skew-y-3 before:h-0.5 before:bg-primary before:absolute before:bottom-0 before:left-0"
                    >
                      {plan.title}
                    </p>
                  </CardTitle>
                  <CardDescription class="text-base">
                    {plan.description}
                  </CardDescription>
                </CardHeader>
                <CardContent class="space-y-6">
                  <div class="space-y-2">
                    <div class="flex flex-col items-center gap-2">
                      <p class="text-muted-foreground line-through text-lg">
                        {plan.price}
                      </p>
                      <p class="text-3xl font-bold text-primary">
                        {plan.actualPrice}
                      </p>
                    </div>
                  </div>
                  <ul class="space-y-3">
                    {#each plan.features as feature, index (index)}
                      <li class="flex items-start gap-2">
                        <Check
                          class="size-5 text-primary mt-0.5 flex-shrink-0"
                        />
                        <span class="text-sm text-muted-foreground">
                          {feature}
                        </span>
                      </li>
                    {/each}
                  </ul>
                </CardContent>
                <CardFooter>
                  <Link href={plan.href}>
                    <Button
                      class="w-full font-brand font-semibold"
                      variant={plan.bestChoice ? 'default' : 'outline'}
                    >
                      {plan.cta}
                      <ArrowUpRight class="size-5" />
                    </Button>
                  </Link>
                </CardFooter>
              </Card>
            {/each}
          </div>
        </div>
      </section>
    </div>
  </div>
</main>

<footer class="bg-background-off border-t py-6">
  <div class="container mx-auto px-4 lg:px-8">
    <div class="flex items-center justify-center gap-2">
      <p class="text-sm text-muted-foreground">Feito com</p>

      <img src={handsHeartIcon} alt="Hands Heart" class="size-8 dark:hidden" />
      <img
        src={handsHeartIconDark}
        alt="Hands Heart Dark"
        class="size-8 hidden dark:block"
      />
    </div>

    <p class="text-center text-sm text-muted-foreground">
      © 2025 Paperhub. Todos os direitos reservados.
    </p>
  </div>
</footer>

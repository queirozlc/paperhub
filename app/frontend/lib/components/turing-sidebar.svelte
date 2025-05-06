<script lang="ts">
  import * as Sidebar from '@/lib/components/ui/sidebar'
  import {
    Edit03,
    Image01,
    InfoCircle,
    MessageQuestionCircle,
    Plus,
    Send01,
    Translate01,
  } from '@voolt_technologies/untitledui-svelte'
  import Button from './ui/button/button.svelte'
  import Textarea from './ui/textarea/textarea.svelte'
  import Icon from './ui/icon/Icon.svelte'

  let question = $state('')

  let ref: HTMLTextAreaElement = $state(null)

  function resize(
    event: Event & {
      currentTarget: EventTarget & HTMLTextAreaElement
    }
  ) {
    if (ref) {
      const target = event.target as HTMLInputElement
      ref.style.height = 'auto'
      ref.style.height = `${target.scrollHeight - 0}px`
    }
  }
</script>

<Sidebar.Root side="right" transparent>
  <Sidebar.Header class="border-sidebar-border h-14 border-b"></Sidebar.Header>
  <Sidebar.Content class="px-2">
    <Sidebar.Group>
      <div class="flex items-center justify-between">
        <span class="text-muted-foreground text-sm font-semibold font-brand"
          >Turing AI</span
        >
        <Button
          size="icon"
          variant="ghost"
          class="hover:text-accent-foreground text-muted-foreground"
        >
          <InfoCircle class="size-4" />
        </Button>
      </div>
    </Sidebar.Group>

    <Sidebar.Group class="items-center h-full justify-center gap-5">
      <div class="flex flex-col items-center justify-center gap-4">
        <div
          class="shadow-md rounded-md bg-popover p-2 w-fit flex items-center justify-center"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="32"
            height="32"
            viewBox="0 0 32 32"
            fill="none"
          >
            <g clip-path="url(#clip0_2895_645)">
              <mask
                id="mask0_2895_645"
                style="mask-type:luminance"
                maskUnits="userSpaceOnUse"
                x="0"
                y="0"
                width="32"
                height="32"
              >
                <path d="M32 0H0V32H32V0Z" fill="white" />
              </mask>
              <g mask="url(#mask0_2895_645)">
                <path
                  d="M15.0414 7.32127C14.9869 6.84021 14.5802 6.47657 14.0961 6.47607C13.612 6.47558 13.2044 6.83838 13.149 7.31934C12.7883 10.4468 11.8532 12.6459 10.3447 14.1543C8.83629 15.6628 6.63718 16.5979 3.50976 16.9586C3.02881 17.014 2.66601 17.4215 2.6665 17.9056C2.667 18.3898 3.03064 18.7966 3.51169 18.851C6.58742 19.1994 8.83328 20.134 10.3775 21.6504C11.916 23.1611 12.8706 25.3596 13.1464 28.4651C13.1901 28.957 13.6024 29.3338 14.0961 29.3332C14.5898 29.3327 15.0013 28.9548 15.044 28.463C15.3082 25.4086 16.262 23.1638 17.8081 21.6176C19.3541 20.0715 21.599 19.1179 24.6534 18.8535C25.1453 18.811 25.523 18.3995 25.5237 17.9058C25.5242 17.412 25.1473 16.9998 24.6556 16.956C21.5501 16.6802 19.3514 15.7256 17.8408 14.1871C16.3245 12.6428 15.3898 10.397 15.0414 7.32127Z"
                  fill="#9AE817"
                />
                <path
                  d="M25.2569 2.99518C25.2357 2.8081 25.0775 2.66669 24.8893 2.6665C24.7009 2.66632 24.5425 2.8074 24.5209 2.99444C24.3806 4.21065 24.017 5.06586 23.4303 5.65249C22.8438 6.23912 21.9885 6.60274 20.7723 6.74302C20.5853 6.76458 20.4442 6.92305 20.4443 7.11133C20.4446 7.2996 20.5859 7.45777 20.773 7.47897C21.9691 7.61445 22.8426 7.97793 23.4431 8.56762C24.0414 9.15509 24.4126 10.0101 24.5199 11.2178C24.5369 11.4091 24.6973 11.5556 24.8893 11.5554C25.0813 11.5552 25.2413 11.4083 25.2578 11.217C25.3606 10.0292 25.7315 9.15614 26.3327 8.55489C26.9341 7.95362 27.807 7.58276 28.9949 7.47994C29.1861 7.46338 29.333 7.30337 29.3333 7.11137C29.3335 6.91936 29.1869 6.75902 28.9957 6.74202C27.7879 6.63476 26.933 6.26353 26.3455 5.66524C25.7558 5.06469 25.3923 4.1913 25.2569 2.99518Z"
                  fill="#9AE817"
                />
              </g>
            </g>
            <defs>
              <clipPath id="clip0_2895_645">
                <rect width="32" height="32" fill="white" />
              </clipPath>
            </defs>
          </svg>
        </div>
        <h3 class="font-brand font-semibold text-sm text-accent-foreground">
          Como posso ajudar ?
        </h3>
      </div>

      <ul class="flex flex-col items-center justify-center gap-4">
        <li
          class="text-muted-foreground cursor-pointer flex items-center hover:underline gap-2"
        >
          <Translate01 class="size-4" />
          <span class="font-medium font-brand text-xs text-center"
            >Leia artigos em qualquer idioma</span
          >
        </li>

        <li
          class="text-muted-foreground cursor-pointer group flex hover:underline items-center gap-2"
        >
          <Edit03 class="size-4" />
          <span class="font-medium font-brand text-xs text-left"
            >Escreva com a ajuda do Turing AI</span
          >
        </li>

        <li
          class="text-muted-foreground cursor-pointer flex hover:underline items-center gap-2"
        >
          <MessageQuestionCircle class="size-4" />
          <span class="font-medium font-brand text-xs text-left"
            >Tire alguma dúvida sobre o tema</span
          >
        </li>
      </ul>
    </Sidebar.Group>
  </Sidebar.Content>

  <Sidebar.Footer class="px-2">
    <div class="flex flex-col justify-center gap-4">
      <Button size="icon" variant="outline" class="size-6">
        <Plus />
      </Button>

      <div class="relative">
        <Textarea
          bind:ref
          placeholder="Do que você está precisando ?"
          class="resize-none pb-10 no-scrollbar"
          bind:value={question}
          oninput={resize}
        />
        <Button
          variant="ghost"
          size="icon"
          class="size-6 absolute bottom-2 left-2 text-muted-foreground hover:text-accent-foreground"
        >
          <Icon name="broom" />
        </Button>

        <div class="absolute gap-2 bottom-2 right-2 flex items-center">
          <Button
            variant="ghost"
            size="icon"
            class="size-6 text-muted-foreground hover:text-accent-foreground"
          >
            <Image01 />
          </Button>

          <Button
            variant="outline"
            size="icon"
            class="size-6 text-muted-foreground hover:text-accent-foreground"
          >
            <Send01 />
          </Button>
        </div>
      </div>

      <div class="flex items-center text-muted-foreground gap-2">
        <InfoCircle class="size-6" />
        <span class="text-xs font-medium">
          Lembre-se sempre de checar se a resposta está correta.
        </span>
      </div>
    </div>
  </Sidebar.Footer>
</Sidebar.Root>

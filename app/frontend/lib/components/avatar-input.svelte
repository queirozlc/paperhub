<script lang="ts">
  import { tv, type VariantProps } from 'tailwind-variants'
  import { cn, defaultAvatar } from '../utils'
  import * as Avatar from './ui/avatar'
  import type { HTMLButtonAttributes } from 'svelte/elements'

  const fileInputVariant = tv({
    base: 'relative rounded-full group overflow-hidden cursor-pointer transition-transform duration-200 ease-in-out select-none',
    variants: {
      size: {
        sm: 'size-10',
        md: 'size-20',
      },
    },
    defaultVariants: {
      size: 'md',
    },
  })

  type FileInputSize = VariantProps<typeof fileInputVariant>['size']

  type Props = {
    initialImage?: string
    size?: FileInputSize
    selectedImage?: File
  } & HTMLButtonAttributes

  let {
    initialImage,
    size,
    class: className,
    selectedImage = $bindable(null),
  }: Props = $props()

  let image = $state(initialImage)
  let fileInput: HTMLInputElement

  function handleFileChange(event: Event) {
    const target = event.target as HTMLInputElement
    const file = target.files?.[0]
    if (file) {
      selectedImage = file
      const reader = new FileReader()
      reader.onload = (e) => {
        image = e.target?.result as string
      }
      reader.readAsDataURL(file)
    }
  }
</script>

<button
  type="button"
  class={cn(fileInputVariant({ size }), className)}
  onclick={() => fileInput.click()}
>
  <div class="w-full h-full flex items-center justify-center">
    <Avatar.Root class="size-full">
      <Avatar.Image
        alt="Profile picture"
        class="size-full object-cover block"
        src={image}
      />
      <Avatar.Fallback>
        <img src={defaultAvatar().toDataUri()} alt="fallback avatar" />
      </Avatar.Fallback>
    </Avatar.Root>
  </div>

  <div
    class="absolute inset-0 bg-black/70 flex items-center justify-center transition-opacity duration-300 rounded-full group-hover:opacity-100 opacity-0"
  >
    <span class="text-background text-center text-xs font-medium font-brand">
      Escolher imagem
    </span>
  </div>

  <input
    type="file"
    name="profilePicture"
    accept="image/*"
    class="absolute w-0 h-0 opacity-0 overflow-hidden"
    bind:this={fileInput}
    onchange={handleFileChange}
  />
</button>

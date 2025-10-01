<script lang="ts">
  import { tv, type VariantProps } from 'tailwind-variants'
  import { cn, defaultAvatar } from '../utils'
  import * as Avatar from './ui/avatar'
  import type { HTMLButtonAttributes } from 'svelte/elements'
  import type { ComponentProps, Snippet } from 'svelte'
  import { Camera } from '@lucide/svelte'

  const fileInputVariant = tv({
    base: 'relative rounded-full group overflow-hidden cursor-pointer transition-transform duration-200 ease-in-out select-none',
    variants: {
      size: {
        sm: 'size-12',
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
    fallback?: Snippet
    avatarProps?: ComponentProps<typeof Avatar.Root>
    imageProps?: ComponentProps<typeof Avatar.Image>
    onFileChange?: (file: File) => void
  } & HTMLButtonAttributes

  let {
    initialImage,
    size,
    class: className,
    selectedImage = $bindable(null),
    fallback,
    avatarProps,
    imageProps,
    onFileChange,
  }: Props = $props()

  let image = $state(initialImage)
  let fileInput: HTMLInputElement

  function handleFileChange(event: Event, onFileChange?: (file: File) => void) {
    const target = event.target as HTMLInputElement
    const file = target.files?.[0]
    if (file) {
      selectedImage = file
      onFileChange?.(file)
      const reader = new FileReader()
      reader.onload = (e) => {
        image = e.target?.result as string
      }
      reader.readAsDataURL(file)
    }
  }
</script>

{#snippet imageFallback()}
  {#if fallback}
    {@render fallback()}
  {:else}
    <img src={defaultAvatar()} alt="fallback avatar" />
  {/if}
{/snippet}

<button
  type="button"
  class={cn(fileInputVariant({ size }), className)}
  onclick={() => fileInput.click()}
>
  <div class="w-full h-full flex items-center justify-center">
    <Avatar.Root class={cn('size-full', avatarProps?.class)} {...avatarProps}>
      <Avatar.Image
        alt="Profile picture"
        class={cn('size-full object-cover block', imageProps?.class)}
        src={image}
        {...imageProps}
      />
      <Avatar.Fallback>
        {@render imageFallback()}
      </Avatar.Fallback>
    </Avatar.Root>
  </div>

  <div
    class="absolute inset-0 bg-black/70 flex items-center justify-center transition-opacity duration-300 rounded-full group-hover:opacity-100 opacity-0"
  >
    <Camera
      class={cn('text-foreground', {
        'size-4': size === 'sm',
        'size-8': size === 'md',
      })}
    />
  </div>

  <input
    type="file"
    name="profilePicture"
    id="profilePicture"
    accept="image/*"
    class="absolute w-0 h-0 opacity-0 overflow-hidden"
    bind:this={fileInput}
    onchange={(e) => handleFileChange(e, onFileChange)}
  />
</button>

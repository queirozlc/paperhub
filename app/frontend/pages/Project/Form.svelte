<script lang="ts">
  import { useForm, type InertiaFormProps } from '@inertiajs/svelte'
  import type { ProjectType, ProjectFormType } from './types'
  import Input from '@/lib/components/ui/input/input.svelte'

  let { project, submitText, onSubmit } = $props<{
    project: ProjectType
    onSubmit: (props: { form: InertiaFormProps<ProjectFormType> }) => void
    submitText: string
  }>()

  const form = useForm<ProjectFormType>({
    title: project.title || '',
    description: project.description || '',
  })

  const handleSubmit = (e: SubmitEvent) => {
    e.preventDefault()
    onSubmit({ form: $form })
  }
</script>

<form class="contents" onsubmit={handleSubmit}>
  <div class="my-5">
    <label for="title">Title</label>
    <Input type="text" name="title" id="title" bind:value={$form.title} />
    {#if $form.errors.title}
      <div class="text-red-500 px-3 py-2 font-medium">
        {$form.errors.title}
      </div>
    {/if}
  </div>

  <div class="my-5">
    <label for="description">Description</label>
    <Input
      type="text"
      name="description"
      id="description"
      bind:value={$form.description}
    />
    {#if $form.errors.description}
      <div class="text-red-500 px-3 py-2 font-medium">
        {$form.errors.description}
      </div>
    {/if}
  </div>

  <div class="inline">
    <button
      type="submit"
      disabled={$form.processing}
      class="rounded-lg py-3 px-5 bg-blue-600 text-white inline-block font-medium cursor-pointer"
    >
      {submitText}
    </button>
  </div>
</form>

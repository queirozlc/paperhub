<script lang="ts">
  import { Link, type InertiaFormProps } from '@inertiajs/svelte'
  import type { ProjectType, ProjectFormType } from './types'
  import Form from './Form.svelte'

  let { project }: { project: ProjectType } = $props()

  const handleSubmit = ({
    form,
  }: {
    form: InertiaFormProps<ProjectFormType>
  }) => {
    form.transform((data) => ({ project: data }))
    form.post('/projects')
  }
</script>

<svelte:head>
  <title>New project</title>
</svelte:head>

<div class="mx-auto md:w-2/3 w-full px-8 pt-8">
  <h1 class="font-bold text-4xl">New project</h1>

  <Form {project} submitText="Create Project" onSubmit={handleSubmit} />

  <Link
    href="/projects"
    class="ml-2 rounded-lg py-3 px-5 bg-gray-600 inline-block font-medium"
  >
    Back to projects
  </Link>
</div>

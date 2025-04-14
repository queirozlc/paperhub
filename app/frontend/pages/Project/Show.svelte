<script lang="ts">
  import { Link } from '@inertiajs/svelte'
  import Project from './Project.svelte'
  import type { ProjectType } from './types'

  let { project, flash } = $props<{
    project: ProjectType
    flash: { notice?: string }
  }>()
</script>

<svelte:head>
  <title>Project #{project.id}</title>
</svelte:head>

<div class="mx-auto md:w-2/3 w-full px-8 pt-8">
  <div class="mx-auto">
    {#if flash.notice}
      <p
        class="py-2 px-3 bg-green-50 mb-5 text-green-500 font-medium rounded-lg inline-block"
      >
        {flash.notice}
      </p>
    {/if}

    <h1 class="font-bold text-4xl">Project #{project.id}</h1>

    <Project {project} />

    <Link
      href={`/projects/${project.id}/edit`}
      class="ml-2 rounded-lg py-3 px-5 bg-gray-800 inline-block font-medium"
    >
      Edit this project
    </Link>
    <Link
      href="/projects"
      class="ml-2 rounded-lg py-3 px-5 bg-gray-800 inline-block font-medium"
    >
      Back to projects
    </Link>
    <div class="inline-block ml-2">
      <Link
        href={`/projects/${project.id}`}
        method="delete"
        class="mt-2 rounded-lg py-3 px-5 bg-gray-800 font-medium"
      >
        Destroy this project
      </Link>
    </div>
  </div>
</div>

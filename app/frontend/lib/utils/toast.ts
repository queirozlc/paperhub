import { toast } from 'svelte-sonner'

export const displayUnavailableFunctionalityToast = () =>
  toast.warning(
    'Esta funcionalidade ainda está indisponível. Estamos trabalhando nisso ;)',
    {
      position: 'bottom-center',
      style: 'background-color: rgb(255, 220, 0); color: black;',
    }
  )

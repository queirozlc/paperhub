import axios from 'axios'
import 'phoenix_html'

import { createInertiaApp } from '@inertiajs/react'
import { createRoot } from 'react-dom/client'
import { ThemeProvider } from './lib/theme-provider'

axios.defaults.xsrfHeaderName = 'x-csrf-token'

createInertiaApp({
  resolve: async (name) => {
    return await import(`./pages/${name}.tsx`)
  },
  setup({ App, el, props }) {
    createRoot(el).render(
      <ThemeProvider defaultTheme='system'>
        <App {...props} />
      </ThemeProvider>
    )
  }
})

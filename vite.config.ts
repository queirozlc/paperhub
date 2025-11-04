import { svelte } from '@sveltejs/vite-plugin-svelte'
import tailwindcss from '@tailwindcss/vite'
import { resolve } from 'path'
import { sveltePreprocess } from 'svelte-preprocess'
import { defineConfig } from 'vite'
import ViteRails from 'vite-plugin-rails'

export default defineConfig({
  build: {
    assetsInlineLimit: 0,
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes('node_modules')) {
            return 'vendor'
          }
        },
      },
    },
  },
  plugins: [
    tailwindcss(),
    ViteRails({}),
    svelte({
      prebundleSvelteLibraries: true,
      preprocess: sveltePreprocess({}),
    }),
  ],
  resolve: {
    alias: {
      $: resolve(__dirname, 'app/frontend'),
      $lib: resolve(__dirname, 'app/frontend/lib'),
      $assets: resolve(__dirname, 'app/frontend/assets'),
      $layouts: resolve(__dirname, 'app/frontend/layouts'),
      $pages: resolve(__dirname, 'app/frontend/pages'),
    },
  },
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./app/frontend/test-setup.ts'],
    include: ['app/frontend/**/*.{test,spec}.{js,mjs,cjs,ts,mts,cts,jsx,tsx}'],
    exclude: ['node_modules', 'dist', '.svelte-kit', 'build'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      reportsDirectory: './coverage',
      include: [
        'app/frontend/lib/**/*.{js,ts,svelte}',
        'app/frontend/pages/**/*.{js,ts,svelte}',
        'app/frontend/layouts/**/*.{js,ts,svelte}',
      ],
      exclude: [
        'app/frontend/**/*.test.{js,ts}',
        'app/frontend/**/*.spec.{js,ts}',
        'app/frontend/test-setup.ts',
        'app/frontend/**/*.d.ts',
      ],
    },

    testTimeout: 10000,
  },
})

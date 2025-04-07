import { defineConfig } from "vite";
import ViteRails from "vite-plugin-rails";
import tailwindcss from "@tailwindcss/vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";
import { sveltePreprocess } from "svelte-preprocess";
import { resolve } from "path";

export default defineConfig({
  build: {
    assetsInlineLimit: 0,
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes("node_modules")) {
            return "vendor";
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
      "@": resolve(__dirname, "app/frontend"),
    },
  },
});

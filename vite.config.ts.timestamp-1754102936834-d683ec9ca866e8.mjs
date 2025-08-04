// vite.config.ts
import { svelte } from "file:///Users/lucasqueiroz/www/paperhub/node_modules/@sveltejs/vite-plugin-svelte/src/index.js";
import tailwindcss from "file:///Users/lucasqueiroz/www/paperhub/node_modules/@tailwindcss/vite/dist/index.mjs";
import { resolve } from "path";
import { sveltePreprocess } from "file:///Users/lucasqueiroz/www/paperhub/node_modules/svelte-preprocess/dist/index.js";
import { defineConfig } from "file:///Users/lucasqueiroz/www/paperhub/node_modules/vite/dist/node/index.js";
import ViteRails from "file:///Users/lucasqueiroz/www/paperhub/node_modules/vite-plugin-rails/dist/index.js";
var __vite_injected_original_dirname = "/Users/lucasqueiroz/www/paperhub";
var vite_config_default = defineConfig({
  build: {
    assetsInlineLimit: 0,
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes("node_modules")) {
            return "vendor";
          }
        }
      }
    }
  },
  plugins: [
    tailwindcss(),
    ViteRails({}),
    svelte({
      prebundleSvelteLibraries: true,
      preprocess: sveltePreprocess({})
    })
  ],
  resolve: {
    alias: {
      $: resolve(__vite_injected_original_dirname, "app/frontend"),
      $lib: resolve(__vite_injected_original_dirname, "app/frontend/lib"),
      $assets: resolve(__vite_injected_original_dirname, "app/frontend/assets"),
      $layouts: resolve(__vite_injected_original_dirname, "app/frontend/layouts"),
      $pages: resolve(__vite_injected_original_dirname, "app/frontend/pages")
    }
  }
});
export {
  vite_config_default as default
};
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsidml0ZS5jb25maWcudHMiXSwKICAic291cmNlc0NvbnRlbnQiOiBbImNvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9kaXJuYW1lID0gXCIvVXNlcnMvbHVjYXNxdWVpcm96L3d3dy9wYXBlcmh1YlwiO2NvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9maWxlbmFtZSA9IFwiL1VzZXJzL2x1Y2FzcXVlaXJvei93d3cvcGFwZXJodWIvdml0ZS5jb25maWcudHNcIjtjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfaW1wb3J0X21ldGFfdXJsID0gXCJmaWxlOi8vL1VzZXJzL2x1Y2FzcXVlaXJvei93d3cvcGFwZXJodWIvdml0ZS5jb25maWcudHNcIjtpbXBvcnQgeyBzdmVsdGUgfSBmcm9tICdAc3ZlbHRlanMvdml0ZS1wbHVnaW4tc3ZlbHRlJ1xuaW1wb3J0IHRhaWx3aW5kY3NzIGZyb20gJ0B0YWlsd2luZGNzcy92aXRlJ1xuaW1wb3J0IHsgcmVzb2x2ZSB9IGZyb20gJ3BhdGgnXG5pbXBvcnQgeyBzdmVsdGVQcmVwcm9jZXNzIH0gZnJvbSAnc3ZlbHRlLXByZXByb2Nlc3MnXG5pbXBvcnQgeyBkZWZpbmVDb25maWcgfSBmcm9tICd2aXRlJ1xuaW1wb3J0IFZpdGVSYWlscyBmcm9tICd2aXRlLXBsdWdpbi1yYWlscydcblxuZXhwb3J0IGRlZmF1bHQgZGVmaW5lQ29uZmlnKHtcbiAgYnVpbGQ6IHtcbiAgICBhc3NldHNJbmxpbmVMaW1pdDogMCxcbiAgICByb2xsdXBPcHRpb25zOiB7XG4gICAgICBvdXRwdXQ6IHtcbiAgICAgICAgbWFudWFsQ2h1bmtzKGlkKSB7XG4gICAgICAgICAgaWYgKGlkLmluY2x1ZGVzKCdub2RlX21vZHVsZXMnKSkge1xuICAgICAgICAgICAgcmV0dXJuICd2ZW5kb3InXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgfSxcbiAgICB9LFxuICB9LFxuICBwbHVnaW5zOiBbXG4gICAgdGFpbHdpbmRjc3MoKSxcbiAgICBWaXRlUmFpbHMoe30pLFxuICAgIHN2ZWx0ZSh7XG4gICAgICBwcmVidW5kbGVTdmVsdGVMaWJyYXJpZXM6IHRydWUsXG4gICAgICBwcmVwcm9jZXNzOiBzdmVsdGVQcmVwcm9jZXNzKHt9KSxcbiAgICB9KSxcbiAgXSxcbiAgcmVzb2x2ZToge1xuICAgIGFsaWFzOiB7XG4gICAgICAkOiByZXNvbHZlKF9fZGlybmFtZSwgJ2FwcC9mcm9udGVuZCcpLFxuICAgICAgJGxpYjogcmVzb2x2ZShfX2Rpcm5hbWUsICdhcHAvZnJvbnRlbmQvbGliJyksXG4gICAgICAkYXNzZXRzOiByZXNvbHZlKF9fZGlybmFtZSwgJ2FwcC9mcm9udGVuZC9hc3NldHMnKSxcbiAgICAgICRsYXlvdXRzOiByZXNvbHZlKF9fZGlybmFtZSwgJ2FwcC9mcm9udGVuZC9sYXlvdXRzJyksXG4gICAgICAkcGFnZXM6IHJlc29sdmUoX19kaXJuYW1lLCAnYXBwL2Zyb250ZW5kL3BhZ2VzJyksXG4gICAgfSxcbiAgfSxcbn0pXG4iXSwKICAibWFwcGluZ3MiOiAiO0FBQWtSLFNBQVMsY0FBYztBQUN6UyxPQUFPLGlCQUFpQjtBQUN4QixTQUFTLGVBQWU7QUFDeEIsU0FBUyx3QkFBd0I7QUFDakMsU0FBUyxvQkFBb0I7QUFDN0IsT0FBTyxlQUFlO0FBTHRCLElBQU0sbUNBQW1DO0FBT3pDLElBQU8sc0JBQVEsYUFBYTtBQUFBLEVBQzFCLE9BQU87QUFBQSxJQUNMLG1CQUFtQjtBQUFBLElBQ25CLGVBQWU7QUFBQSxNQUNiLFFBQVE7QUFBQSxRQUNOLGFBQWEsSUFBSTtBQUNmLGNBQUksR0FBRyxTQUFTLGNBQWMsR0FBRztBQUMvQixtQkFBTztBQUFBLFVBQ1Q7QUFBQSxRQUNGO0FBQUEsTUFDRjtBQUFBLElBQ0Y7QUFBQSxFQUNGO0FBQUEsRUFDQSxTQUFTO0FBQUEsSUFDUCxZQUFZO0FBQUEsSUFDWixVQUFVLENBQUMsQ0FBQztBQUFBLElBQ1osT0FBTztBQUFBLE1BQ0wsMEJBQTBCO0FBQUEsTUFDMUIsWUFBWSxpQkFBaUIsQ0FBQyxDQUFDO0FBQUEsSUFDakMsQ0FBQztBQUFBLEVBQ0g7QUFBQSxFQUNBLFNBQVM7QUFBQSxJQUNQLE9BQU87QUFBQSxNQUNMLEdBQUcsUUFBUSxrQ0FBVyxjQUFjO0FBQUEsTUFDcEMsTUFBTSxRQUFRLGtDQUFXLGtCQUFrQjtBQUFBLE1BQzNDLFNBQVMsUUFBUSxrQ0FBVyxxQkFBcUI7QUFBQSxNQUNqRCxVQUFVLFFBQVEsa0NBQVcsc0JBQXNCO0FBQUEsTUFDbkQsUUFBUSxRQUFRLGtDQUFXLG9CQUFvQjtBQUFBLElBQ2pEO0FBQUEsRUFDRjtBQUNGLENBQUM7IiwKICAibmFtZXMiOiBbXQp9Cg==

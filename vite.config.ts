import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";
import { componentTagger } from "lovable-tagger";

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => ({
  server: {
    host: "0.0.0.0", // Allows connections from all network interfaces (IPv4)
    port: 8080, // Port for the development server
  },
  build: {
    outDir: "build", // Ensure the output directory is set to 'build'
    emptyOutDir: true, // Clears the output directory before building
  },
  plugins: [
    react(),
    mode === "development" && componentTagger(),
  ].filter(Boolean),
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"), // Alias for the 'src' directory
    },
  },
}));

#!/bin/bash

# Prompt for project name
read -p "Enter the project name: " project_name

# Initialize a new Vite project with React TypeScript template
npx create-vite "$project_name" --template react-ts
cd "$project_name"

# Install Tailwind CSS dependencies
npm install --save-dev tailwindcss@latest postcss@latest autoprefixer@latest

# Create Tailwind CSS configuration files
npx tailwindcss init -p

# Update src/index.css with Tailwind CSS imports
echo '@tailwind base;' > src/index.css
echo '@tailwind components;' >> src/index.css
echo '@tailwind utilities;' >> src/index.css

# add content in tailwind config
echo 'export default {' >> tailwind.config.js
echo 'content: ["./src/**/*.{js,jsx,ts,tsx}"],' >> tailwind.config.js
echo 'theme: { extend: {} },' >> tailwind.config.js
echo 'variants: {},' >> tailwind.config.js
echo 'plugins: []' >> tailwind.config.js
echo '}' >> tailwind.config.js

# modify vite config to use tailwindcss
echo 'import { defineConfig } from "vite"' > vite.config.ts
echo 'import react from "@vitejs/plugin-react"' >> vite.config.ts
echo 'import tailwindcss from "tailwindcss"' >> vite.config.ts
echo 'export default defineConfig({' >> vite.config.ts
echo 'plugins: [react()],' >> vite.config.ts
echo 'css: {' >> vite.config.ts
echo 'postcss: {' >> vite.config.ts
echo 'plugins: [' >> vite.config.ts
echo 'tailwindcss,' >> vite.config.ts
echo 'require("autoprefixer")' >> vite.config.ts
echo '],' >> vite.config.ts
echo '}' >> vite.config.ts
echo '}' >> vite.config.ts
echo '})' >> vite.config.ts

# remove unnecessary css
rm src/App.css

# modify app.tsx to show sample div with tailwind css
echo 'import React from "react"' > src/App.tsx
echo 'function App() {' >> src/App.tsx
echo 'return (' >> src/App.tsx
echo '<div className="bg-gray-500">' >> src/App.tsx
echo 'hello' >> src/App.tsx
echo '</div>' >> src/App.tsx
echo ')' >> src/App.tsx
echo '}' >> src/App.tsx
echo 'export default App' >> src/App.tsx

# Install React Router and its TypeScript typings
npm install react-router-dom
npm install --save-dev @types/react-router-dom

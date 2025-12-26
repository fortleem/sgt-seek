/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './lib/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        sgt: {
          blue: '#1e40af',
          green: '#10b981',
          gold: '#f59e0b',
          slate: '#1e293b'
        }
      }
    },
  },
  plugins: [],
}

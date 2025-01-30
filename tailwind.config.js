/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {
      colors: {
        primary: '#2C3E50',
        secondary: '#34495E',
        accent: '#E74C3C'
      }
    }
  },
  plugins: []
}
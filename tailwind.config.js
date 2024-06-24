/** @type {import('tailwindcss').Config} */
module.exports = {
  
  presets: [
    require('decanter')
  ],
  content: [
    './docs/*.html',
    './docs/templates/*.html',
    './docs/js/*.js'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}


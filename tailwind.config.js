/** @type {import('tailwindcss').Config} */
module.exports = {
  presets: [
    require('decanter')
  ],
  content: [
    './*.html',
    './templates/*.html',
    './js/*.js',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}


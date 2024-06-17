/** @type {import('tailwindcss').Config} */
module.exports = {
  presets: [
    require('decanter')
  ],
  content: ['./docs/index.html', './docs/info.html', './docs/resources.html', './js/load_templates.js'],
  theme: {
    extend: {},
  },
  plugins: [],
}


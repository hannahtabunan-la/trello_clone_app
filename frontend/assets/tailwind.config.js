module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
    container: {
      center:true
    },
    pink: {
      light: '#ee8080',
      DEFAULT: '#ee8080',
      dark: '#d03161',
    },
    blue: {
      light: '#5488B6',
      DEFAULT: '#497EAB',
      dark: '#43739D',
    },
    backgroundImage: theme => ({
      'main': "linear-gradient(#355C7D, #95829d)"
     }),
    backgroundColor: theme => ({
      ...theme('colors'),
      'primary': '#355C7D',
      'secondary': '#95829d',
      'danger': '#e3342f',
      'primary-300': '#475E89',
      'violet': '#6c5b7b',
      'violet-900': '#4f3e5e',
      'violet-800': '#625071',
      'violet-700': '#68527A',
      'violet-500': '#826599',
      'violet-300': '#8d7f9a',
      'violet-100': '#b4abbc'
     }),
     textColor: theme => ({
       ...theme('colors'),
      'violet': '#6c5b7b',
      'violet-900': '#4f3e5e',
      'violet-800': '#625071',
      'violet-700': '#68527A',
      'violet-500': '#826599',
      'violet-300': '#8d7f9a',
      'violet-100': '#b4abbc',
      'yellow': '#E3D26F'
     }),
     borderColor: theme => ({
      ...theme('colors'),
     'violet': '#6c5b7b',
     'violet-900': '#4f3e5e',
     'violet-800': '#625071',
     'violet-700': '#68527A',
     'violet-500': '#826599',
     'violet-300': '#8d7f9a',
     'violet-100': '#b4abbc',
     'yellow': '#E3D26F'
    })
  },
  variants: {
    extend: {},
  },
  plugins: [],
}

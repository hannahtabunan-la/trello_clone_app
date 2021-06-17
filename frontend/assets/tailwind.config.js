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
      'primary': '#3490dc',
      'secondary': '#ffed4a',
      'danger': '#e3342f',
      'violet': '#6c5b7b',
      'violet-800': '#625071',
      'violet-700': '#68527A',
      'violet-500': '#826599',
      'gray': '#6c5b7b',
      'gray-700': '#5B585F',
      'gray-500': '#6E6B73'
     }),
     textColor: theme => ({
       ...theme('colors'),
      'violet': '#6c5b7b',
      'violet-800': '#625071',
      'violet-700': '#68527A',
      'violet-500': '#826599',
      'yellow': '#E3D26F'
     })
  },
  variants: {
    extend: {},
  },
  plugins: [],
}

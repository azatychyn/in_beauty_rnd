const colors = require('tailwindcss/colors');
const plugin = require("tailwindcss/plugin");

module.exports = {
  mode: "jit",
  purge: {
    // enabled: true, 
    content: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  },
  darkMode: 'class', // or 'media' or 'class'
  theme: {
    // fontFamily: {
    //   display: ['Poppins', 'system-ui', 'sans-serif'],
    //   body: ['Poppins', 'system-ui', 'sans-serif'],
    // },
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      black: colors.black,
      white: colors.white,
      gray: colors.gray,
      orange: colors.orange,
      fuchsia: colors.fuchsia,
      rose: colors.rose,
      pink: colors.pink,
      indigo: colors.indigo,
      red: colors.red,
      violet: colors.violet,
      'midnight': {
        '50': '#f3f4f5', 
        '100': '#e8e8eb', 
        '200': '#c5c6ce', 
        '300': '#a3a4b0', 
        '400': '#5d5f75', 
        '500': '#181b3a', 
        '600': '#161834', 
        '700': '#12142c', 
        '800': '#0e1023', 
        '900': '#0c0d1c'
      },
      'denim': {
        '50': '#868fcd',
        '100': '#727ab4',
        '200': '#5d659a',
        '300': '#495081',
        '400': '#343b67',
        '500': '#20264e',
        '600': '#181d3b',
        '700': '#101327',
        '800': '#080a14',
        '900': '#000000',
      },
      'asphalt': '#5A5959',
      // "white": "#ffffff",
      'text_background': '#eee0df',
      'snow-dribble': '#f9f9f9',
      'lavender-blush': '#FCF7FA',
      'input-border': '#f5dae9',
      'pink-dark-dribble': '#F4ABAE',
      'grey-dribble': '#5C5657',
      'orange-dribble': '#E9663E', 
      'bright-pink-dribble': '#fd0054',

      // from site with colors
      'tutu-dribble': '#FAE0E0',
      'light-purple-dribble': '#E0E0FA',
      'light-cyan-dribble': '#E0FAFA',
      'bridal-heath-dribble': '#FAEDE0',
      // from site with colors

      'light_pink': '#dfc9d2',
      'main-pink': '#4b193b',
      'pink_hover': '#e1cdcc',
      'pink_active': '#a6718c',
      'icon_color': '#c8b3dd',
      'white': '#FFFFFF',
      'white_text': '#F8FBFE',
      'light-blue': '#ECF2F9',
      'light-blue_text': '#C9D7E7',
      'dark-gray-text': '#2C3949',
      'select-grey': '#ECF2F9', 
      'dark-text': '#e7e8eb',      
      'dark-black-russian':'#080c26'
    },
    extend: {
      screens: {      
        'xs': '400px',
      },
      zIndex: {
        '-10': '-10',
       },
      transitionProperty: {
        'height': 'height',
      },
      spacing: {
        '120': '30rem',
        '136': '34rem',
        '152': '38rem',
        '168': '42rem',
        '184': '46rem',
        '200': '50rem',
        '216': '54rem',
        '232': '58rem',
      },
      borderWidth: {
        '120': '120px',
        '40': '40px', 
        '32': '32px',
        '16': '16px', 
      },
      borderRadius: {
        '4xl': '2rem', // 32px
        '5xl': '2.5rem', // 40px
        '6xl': '3rem', // 48px
        '7xl': '3.5rem', // 56px
        '8xl': '4rem', // 64px
        '9xl': '4.5rem', // 72px
        '10xl': '5rem', // 80px
        '11xl': '6rem', // 96px
        '12xl': '7rem', // 112px
        '13xl': '8rem', // 128px
        '14xl': '9rem', // 144px
        '15xl': '10rem', // 160px
      },
      backgroundImage:  {
        'ru-flag': 'linear-gradient(-180deg, white 33.3%, mediumblue 33.3%, mediumblue 66.6%, red 66.6%);',
        'en-flag': 'linear-gradient(90deg, transparent 46%, red 46%, red 56%, transparent 56%),linear-gradient(transparent 38%, white 38%, white 42%, red 42%, red 58%, white 58%, white 62%, transparent 62%), linear-gradient(90deg, transparent 44%, white 44%, white 46%, red 46%, red 56%, white 56%, white 58%, transparent 58%), linear-gradient(33deg, transparent 45%, white 45%, white 48%, red 48%, red 54%, white 54%, white 57%, transparent 57%), linear-gradient(-33deg, mediumblue 45%, white 45%, white 48%, red 48%, red 54%, white 54%, white 57%, mediumblue 57%);', 
        'am-flag': 'linear-gradient(-180deg, red 33.3%, mediumblue 33.3%, mediumblue 66.6%, orange 66.6%)', 
        "arrow-down": 'conic-gradient(from 0deg, #FAE8FF 0% 15%,white 15% 85%, #FAE8FF 85% 0%)',
        'darktheme-gradient-text': 'linear-gradient(90deg, #f96d77 0%, #fcab87 99%)',
      },
      height: {
        '15v': '15vw'    
      },
      animation: {
        pulse: 'pulse 1s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },                
    },
  },
  variants: {
    extend: {
      fontWeight: ['hover', 'focus'],
      display: ['hover', 'focus', 'group-hover'],
      backgroundColor: ['focus-visible', 'checked', 'label-checked'],
      wordBreak: ['group-hover'],
      textOverflow: ['group-hover'],
      flex: ['hover', 'focus'],
      flexGrow: ['hover', 'focus'],
      width: ['hover', 'focus'],
      margin: ['first', 'last'],
      ringWidth: ['hover', 'active', 'group-hover'],
      scale: ['hover'],
      ringOffsetWidth: ['dark'],
      ringWidth: ['dark'],
    },
  },
  corePlugins: {
    // container: false
  },
  plugins: [
    plugin(({ addVariant, e }) => {
        addVariant('label-checked', ({ modifySelectors, separator }) => {
            modifySelectors(
                ({ className }) => {
                    const eClassName = e(`label-checked${separator}${className}`); // escape class
                    const yourSelector = 'input[type="radio"]'; // your input selector. Could be any
                    return `${yourSelector}:checked ~ .${eClassName}`; // ~ - CSS selector for siblings
                }
            )
        })
    }),
    plugin(function ({ addVariant, e, postcss }) {
      addVariant("firefox", ({ container, separator }) => {
        const isFirefoxRule = postcss.atRule({
          name: "-moz-document",
          params: "url-prefix()",
        });
        isFirefoxRule.append(container.nodes);
        container.append(isFirefoxRule);
        isFirefoxRule.walkRules((rule) => {
          rule.selector = `.${e(
            `firefox${separator}${rule.selector.slice(1)}`
          )}`;
        });
      });
    }),
  ],
}

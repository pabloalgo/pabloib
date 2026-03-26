/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./layouts/**/*.html",
    "./content/**/*.md",
    "./static/js/**/*.js"
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        // Design System - Editorial Tech
        'surface-variant': '#dae2fd',
        'surface-container-highest': '#dae2fd',
        'inverse-surface': '#283044',
        'surface-tint': '#006780',
        'primary-container': '#007f9d',
        'outline': '#6e797e',
        'on-background': '#131b2e',
        'surface-container-low': '#f2f3ff',
        'on-primary-container': '#fafdff',
        'on-surface': '#131b2e',
        'surface': '#faf8ff',
        'primary': '#00647c',
        'on-primary': '#ffffff',
        'on-secondary-container': '#466977',
        'inverse-on-surface': '#eef0ff',
        'surface-container-lowest': '#ffffff',
        'secondary-fixed': '#c3e8f8',
        'secondary': '#406370',
        'background': '#faf8ff',
        'surface-dim': '#d2d9f4',
        'primary-fixed': '#b7eaff',
        'inverse-primary': '#6cd3f7',
        'outline-variant': '#bdc8ce',
        'secondary-container': '#c3e8f8',
        'on-surface-variant': '#3e484d',
        'surface-container-high': '#e2e7ff',
        'secondary-fixed-dim': '#a8ccdb',
        'surface-bright': '#faf8ff',
      },
      fontFamily: {
        'headline': ['"Plus Jakarta Sans"', 'sans-serif'],
        'body': ['Inter', 'sans-serif'],
        'label': ['"Space Grotesk"', 'sans-serif'],
      },
      borderRadius: {
        'DEFAULT': '0.125rem',
        'lg': '0.25rem',
        'xl': '0.5rem',
        'full': '0.75rem',
      },
    },
  },
  plugins: [],
}

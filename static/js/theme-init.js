// ============================================
// PABLO IB - Theme Init (synchronous, runs in head)
// Prevents dark mode flash before page renders
// ============================================
(function() {
  var getTheme = function() {
    if (localStorage.getItem('theme')) return localStorage.getItem('theme');
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  };
  if (getTheme() === 'dark') document.documentElement.classList.add('dark');
})();

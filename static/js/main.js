// ============================================
// PABLO IB - Blog Functionality
// Search, Filter, Copy Code
// ============================================

// === Search with Fuse.js ===
document.addEventListener('DOMContentLoaded', async () => {
  const searchInput = document.querySelector('input[placeholder*="Explorar"], input[placeholder*="Buscar"]');
  
  if (!searchInput) return;

  // Load Fuse.js
  if (typeof Fuse === 'undefined') {
    const script = document.createElement('script');
    script.src = 'https://cdn.jsdelivr.net/npm/fuse.js@7.0.0/dist/fuse.min.js';
    document.head.appendChild(script);
    await new Promise(resolve => script.onload = resolve);
  }

  // Fetch search index
  let posts = [];
  try {
    const response = await fetch('/index.json');
    const data = await response.json();
    posts = data.items || data;
  } catch (e) {
    console.log('Search: Could not load index.json');
    return;
  }

  // Initialize Fuse
  const fuse = new Fuse(posts, {
    keys: ['title', 'content', 'tags', 'categories'],
    threshold: 0.4,
    includeScore: true,
    ignoreLocation: true,
  });

  // Create results container
  const resultsContainer = document.createElement('div');
  resultsContainer.className = 'search-results mt-4 space-y-4 hidden';
  searchInput.parentElement.parentElement.appendChild(resultsContainer);

  // Search on input
  let debounceTimer;
  searchInput.addEventListener('input', (e) => {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      const query = e.target.value.trim();
      
      if (query.length < 2) {
        resultsContainer.classList.add('hidden');
        resultsContainer.innerHTML = '';
        return;
      }

      const results = fuse.search(query, { limit: 5 });
      
      if (results.length === 0) {
        resultsContainer.innerHTML = `
          <div class="p-4 bg-surface-container-low rounded-xl text-center font-body text-on-surface-variant">
            No se encontraron resultados para "${query}"
          </div>
        `;
        resultsContainer.classList.remove('hidden');
        return;
      }

      resultsContainer.innerHTML = results.map(result => {
        const post = result.item;
        const url = post.url || post.permalink || '#';
        const title = post.title || 'Sin título';
        const excerpt = (post.content || post.summary || '').substring(0, 100);
        const date = post.date ? new Date(post.date).toLocaleDateString('es-ES', { day: 'numeric', month: 'short', year: 'numeric' }) : '';
        
        return `
          <a href="${url}" class="block p-4 bg-surface-container-low rounded-xl hover:bg-surface-container transition-colors group">
            <div class="flex items-center gap-2 mb-2">
              <span class="font-label text-[10px] uppercase tracking-widest text-primary font-bold">${post.categories?.[0] || 'Blog'}</span>
              ${date ? `<span class="w-1 h-1 rounded-full bg-outline-variant"></span><span class="font-label text-[10px] uppercase tracking-widest text-outline">${date}</span>` : ''}
            </div>
            <h3 class="font-headline font-bold text-on-surface group-hover:text-primary transition-colors">${title}</h3>
            <p class="text-sm font-body text-on-surface-variant mt-1">${excerpt}...</p>
          </a>
        `;
      }).join('');
      
      resultsContainer.classList.remove('hidden');
    }, 300);
  });

  // Close results on click outside
  document.addEventListener('click', (e) => {
    if (!searchInput.contains(e.target) && !resultsContainer.contains(e.target)) {
      resultsContainer.classList.add('hidden');
    }
  });
});

// === Category Filter ===
document.addEventListener('DOMContentLoaded', () => {
  const categoryButtons = document.querySelectorAll('section.-mx-5 button');
  const articles = document.querySelectorAll('section.space-y-16 > article');
  
  if (categoryButtons.length === 0 || articles.length === 0) return;

  categoryButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      const category = btn.textContent.trim();
      
      // Update active button
      categoryButtons.forEach(b => {
        b.classList.remove('bg-primary-container', 'text-on-primary-container');
        b.classList.add('bg-surface-container-highest', 'text-on-surface-variant');
      });
      btn.classList.remove('bg-surface-container-highest', 'text-on-surface-variant');
      btn.classList.add('bg-primary-container', 'text-on-primary-container');

      // Filter articles
      if (category === 'All') {
        articles.forEach(article => {
          article.style.display = '';
        });
        return;
      }

      articles.forEach(article => {
        const articleCategory = article.querySelector('.text-primary')?.textContent?.trim() || '';
        if (articleCategory.toLowerCase().includes(category.toLowerCase())) {
          article.style.display = '';
        } else {
          article.style.display = 'none';
        }
      });
    });
  });
});

// === Copy Code Button ===
document.addEventListener('DOMContentLoaded', () => {
  const codeBlocks = document.querySelectorAll('pre code, .prose pre');
  
  codeBlocks.forEach(block => {
    const pre = block.tagName === 'CODE' ? block.parentElement : block;
    
    // Create wrapper
    const wrapper = document.createElement('div');
    wrapper.className = 'relative group';
    pre.parentNode.insertBefore(wrapper, pre);
    wrapper.appendChild(pre);
    
    // Create copy button
    const copyBtn = document.createElement('button');
    copyBtn.className = 'absolute top-2 right-2 p-2 bg-slate-700 dark:bg-slate-600 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity';
    copyBtn.innerHTML = `
      <svg class="w-4 h-4 text-slate-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"/>
      </svg>
    `;
    copyBtn.setAttribute('aria-label', 'Copiar código');
    wrapper.appendChild(copyBtn);
    
    // Copy functionality
    copyBtn.addEventListener('click', async () => {
      const code = block.textContent;
      
      try {
        await navigator.clipboard.writeText(code);
        
        // Show feedback
        copyBtn.innerHTML = `
          <svg class="w-4 h-4 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
          </svg>
        `;
        
        setTimeout(() => {
          copyBtn.innerHTML = `
            <svg class="w-4 h-4 text-slate-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"/>
            </svg>
          `;
        }, 2000);
      } catch (err) {
        console.error('Failed to copy:', err);
      }
    });
  });
});

// === Lazy Load Images ===
document.addEventListener('DOMContentLoaded', () => {
  const images = document.querySelectorAll('img:not([loading])');
  
  images.forEach(img => {
    img.setAttribute('loading', 'lazy');
    
    // Add fade-in effect
    if (!img.complete) {
      img.style.opacity = '0';
      img.style.transition = 'opacity 0.3s ease';
      img.addEventListener('load', () => {
        img.style.opacity = '1';
      });
    }
  });
});

// === Scroll Progress Indicator ===
document.addEventListener('DOMContentLoaded', () => {
  const progressBar = document.getElementById('scroll-progress');
  if (!progressBar) return;

  const updateProgress = () => {
    const scrollTop = window.scrollY;
    const docHeight = document.documentElement.scrollHeight - window.innerHeight;
    const progress = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0;
    progressBar.style.width = `${progress}%`;
  };

  window.addEventListener('scroll', updateProgress, { passive: true });
  updateProgress();
});

// === Back to Top Button ===
document.addEventListener('DOMContentLoaded', () => {
  const backToTop = document.getElementById('back-to-top');
  if (!backToTop) return;

  const toggleButton = () => {
    if (window.scrollY > 500) {
      backToTop.classList.remove('opacity-0', 'translate-y-4', 'pointer-events-none');
      backToTop.classList.add('opacity-100', 'translate-y-0', 'pointer-events-auto');
    } else {
      backToTop.classList.add('opacity-0', 'translate-y-4', 'pointer-events-none');
      backToTop.classList.remove('opacity-100', 'translate-y-0', 'pointer-events-auto');
    }
  };

  window.addEventListener('scroll', toggleButton, { passive: true });

  backToTop.addEventListener('click', () => {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  });
});

// === Intelligent Prefetch ===
document.addEventListener('DOMContentLoaded', () => {
  // Only on desktop with fast connection
  if (window.matchMedia('(hover: hover)').matches && 
      navigator.connection?.effectiveType !== 'slow-2g') {
    
    const prefetchCache = new Set();
    
    const prefetchLink = (url) => {
      if (prefetchCache.has(url)) return;
      prefetchCache.add(url);
      
      const link = document.createElement('link');
      link.rel = 'prefetch';
      link.href = url;
      link.as = 'document';
      document.head.appendChild(link);
    };

    // Prefetch on hover after 200ms delay
    let hoverTimer;
    document.querySelectorAll('a[href^="/"]').forEach(link => {
      link.addEventListener('mouseenter', () => {
        hoverTimer = setTimeout(() => {
          prefetchLink(link.href);
        }, 200);
      });
      
      link.addEventListener('mouseleave', () => {
        clearTimeout(hoverTimer);
      });
    });

    // Prefetch visible links in viewport
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const link = entry.target;
          if (link.href && link.href.startsWith(window.location.origin)) {
            setTimeout(() => prefetchLink(link.href), 1000);
          }
        }
      });
    }, { rootMargin: '100px' });

    document.querySelectorAll('a[href^="/"]').forEach(link => {
      observer.observe(link);
    });
  }
});


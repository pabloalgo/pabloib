// ============================================
// PABLO IB - Service Worker
// Cache Strategy: Stale While Revalidate
// ============================================

const CACHE_NAME = 'pabloib-v1';
const STATIC_CACHE = 'pabloib-static-v1';
const DYNAMIC_CACHE = 'pabloib-dynamic-v1';

// Assets to cache immediately on install
const STATIC_ASSETS = [
  '/',
  '/index.json',
  '/js/main.js',
  '/manifest.json',
  '/favicon.ico',
  '/apple-touch-icon.png'
];

// Install - cache static assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(STATIC_CACHE)
      .then((cache) => {
        console.log('[SW] Caching static assets');
        return cache.addAll(STATIC_ASSETS);
      })
      .then(() => self.skipWaiting())
  );
});

// Activate - clean old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => {
        return Promise.all(
          keys
            .filter((key) => key !== STATIC_CACHE && key !== DYNAMIC_CACHE)
            .map((key) => {
              console.log('[SW] Removing old cache:', key);
              return caches.delete(key);
            })
        );
      })
      .then(() => self.clients.claim())
  );
});

// Fetch - Stale While Revalidate strategy
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // Skip non-GET requests
  if (request.method !== 'GET') return;

  // Skip external requests
  if (url.origin !== location.origin) return;

  // Skip admin and api routes
  if (url.pathname.startsWith('/admin') || url.pathname.startsWith('/api')) return;

  event.respondWith(
    caches.match(request)
      .then((cachedResponse) => {
        // Return cached response immediately
        const fetchPromise = fetch(request)
          .then((networkResponse) => {
            // Update cache with fresh response
            if (networkResponse && networkResponse.status === 200) {
              const responseClone = networkResponse.clone();
              caches.open(DYNAMIC_CACHE)
                .then((cache) => cache.put(request, responseClone));
            }
            return networkResponse;
          })
          .catch(() => {
            // Return cached response if network fails
            return cachedResponse;
          });

        return cachedResponse || fetchPromise;
      })
  );
});

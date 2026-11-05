/* Offline support for the lesson.
   The page and its fonts are cached on first visit; afterwards the lesson opens from the
   device even when the classroom Wi-Fi drops. The page itself is served from cache at once
   and refreshed in the background, so an edit pushed to GitHub shows up on the next visit.
   Bump VERSION whenever a file in ASSETS other than index.html changes (e.g. rebuilt fonts). */
const VERSION = 'giche-v2';
const ASSETS = [
  './',
  'fonts/noto-serif-kr.woff2',
  'fonts/source-serif-4.woff2',
  'fonts/source-serif-4-italic.woff2',
  'fonts/nanum-pen-script.woff2',
];

self.addEventListener('install', e => {
  // cache:'reload' skips the browser's HTTP cache (GitHub Pages allows 10 min), so a fresh deploy is cached, not the old copy.
  e.waitUntil(caches.open(VERSION)
    .then(c => c.addAll(ASSETS.map(u => new Request(u, { cache: 'reload' }))))
    .then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k.startsWith('giche-') && k !== VERSION).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET' || new URL(req.url).origin !== location.origin) return;

  if (req.mode === 'navigate') {
    // Stale-while-revalidate: open instantly from cache, update it quietly when the network allows.
    const page = new URL('./', self.registration.scope).href;
    e.respondWith(caches.open(VERSION).then(async c => {
      const cached = await c.match(page);
      const fresh = fetch(req, { cache: 'no-cache' })
        .then(r => { if (r.ok) c.put(page, r.clone()); return r; })
        .catch(() => null);
      if (cached) { e.waitUntil(fresh); return cached; }
      return (await fresh) || new Response('오프라인입니다. 와이파이가 될 때 한 번 열어 두면 다음부터는 인터넷 없이 열립니다.',
        { status: 503, headers: { 'Content-Type': 'text/plain; charset=utf-8' } });
    }));
    return;
  }

  // Fonts and other static files: cache first.
  e.respondWith(caches.match(req, { ignoreSearch: true }).then(hit => hit || fetch(req).then(r => {
    if (r.ok) { const copy = r.clone(); caches.open(VERSION).then(c => c.put(req, copy)); }
    return r;
  })));
});

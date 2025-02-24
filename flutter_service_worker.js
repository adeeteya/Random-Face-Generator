'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "5f745668c2ddff03420f5d797a5fd853",
"assets/AssetManifest.bin.json": "f863edbb2172ff93b162eac35e87dc5d",
"assets/AssetManifest.json": "3be3df457d8311ade16cc96adb10929f",
"assets/assets/app_icon.png": "fe0fa25ac4545ed4bcecd6675c93ad35",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "549e27b2d6e32dc78408d4ad68c6ab07",
"assets/NOTICES": "e574b5a56d7940202dc0fae8033166c9",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "8cf6e87eff144e2453a9640bfa1a4ad0",
"canvaskit/canvaskit.js.symbols": "8d7b042615c3df3b6084a43f4cbab201",
"canvaskit/canvaskit.wasm": "f2bff9540242b13879d64cad2240f3d7",
"canvaskit/chromium/canvaskit.js": "9dc7a140b1f0755e6321e9c61b9bd4d9",
"canvaskit/chromium/canvaskit.js.symbols": "fb34b276adaa25a69526127d3eb90c16",
"canvaskit/chromium/canvaskit.wasm": "c03ca38cf9e6d7c428fb4002bc85f4e7",
"canvaskit/skwasm.js": "9c817487f9f24229450747c66b9374a6",
"canvaskit/skwasm.js.symbols": "7157d996c331b2a9e316b6ec288305ad",
"canvaskit/skwasm.wasm": "a789594257ac1bdad1f89ec1bb3a823d",
"canvaskit/skwasm_st.js": "7df9d8484fef4ca8fff6eb4f419a89f8",
"canvaskit/skwasm_st.js.symbols": "21bd5519d3b07c5c54daf3ce328fbf37",
"canvaskit/skwasm_st.wasm": "48287a212ba5f76ff8d45a852ee51441",
"favicon.png": "d4900af299da586d04b064a7f774afdc",
"flutter.js": "1e28bc80be052b70b1e92d55bea86b2a",
"flutter_bootstrap.js": "0e571eabd88179481d222311dfc193c0",
"icons/Icon-192.png": "cb7f649544128dc74433950fa0a3860a",
"icons/Icon-512.png": "0589e1e71d9cf20ff247b3c8143ddd68",
"icons/Icon-maskable-192.png": "cb7f649544128dc74433950fa0a3860a",
"icons/Icon-maskable-512.png": "0589e1e71d9cf20ff247b3c8143ddd68",
"index.html": "387ca7a2a39853ae5b57042453a17695",
"/": "387ca7a2a39853ae5b57042453a17695",
"main.dart.js": "ad3b56a91f5410e36e5f0c041c1481eb",
"main.dart.mjs": "8b44fe250a1b17ef0d98e9e3a73076bb",
"main.dart.wasm": "b1292a6896e974a3d4c25e2c469386fa",
"main.dart.wasm.map": "789fd0e13814d245669ee3ab1b793535",
"manifest.json": "4b2d2e2e3e1025040d6c70a308ce7962",
"splash/img/dark-1x.png": "dba5dc265ab2c51cb5c2c4d7f46769ec",
"splash/img/dark-2x.png": "4daedb157e4af0d17289b376c37448be",
"splash/img/dark-3x.png": "d2f61a16c25fe7bb5d5028df8a87611b",
"splash/img/dark-4x.png": "af9f1baddef2fc09df374f5635eabd39",
"splash/img/light-1x.png": "dba5dc265ab2c51cb5c2c4d7f46769ec",
"splash/img/light-2x.png": "4daedb157e4af0d17289b376c37448be",
"splash/img/light-3x.png": "d2f61a16c25fe7bb5d5028df8a87611b",
"splash/img/light-4x.png": "af9f1baddef2fc09df374f5635eabd39",
"version.json": "b5838128a2f6be08bc4e301de849ec7e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

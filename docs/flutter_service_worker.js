'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "8ef33961ec0405d153577e286bb86410",
"assets/AssetManifest.json": "85b64e3e23e8a6835e67d145ff96c60a",
"assets/assets/images/asteroid1.png": "4c8b9ff85d95fb35df18d177471bf3b1",
"assets/assets/images/asteroid2.png": "103c9fc023d9c7d43504e85fad6c0245",
"assets/assets/images/asteroid3.png": "9ed89c7fa6405131d9d33ce2c1de777f",
"assets/assets/images/asteroid4.png": "0dc76dacbbe6c0ec93c822c62abd39b2",
"assets/assets/images/asteroid5.png": "29f6999716ce61f0aecaa726bfd26d3e",
"assets/assets/images/asteroid6.png": "9525c0e6c5ec591e9967190b1a250808",
"assets/assets/images/asteroid7.png": "2219ae4cfcdb735915d4a235d9501e5b",
"assets/assets/images/asteroid8.png": "b982f35158f81cbc4ef2c551eb6d6ffa",
"assets/assets/images/asteroid9.png": "2115c4872c0f3dc6f621fe9fc7348753",
"assets/assets/images/background.png": "46094e550879ea1567482da874ff1a84",
"assets/assets/images/black_hole.png": "a688a3fc3deef0b2d17b7a3d2741b7c5",
"assets/assets/images/bullet0.png": "096ce5c923242145306619120520b1a4",
"assets/assets/images/bullet1.png": "96ac37e04c6c79bd3239284f6910277f",
"assets/assets/images/bullet2.png": "4e34fd9b3cc973de43a6755fe1225dc9",
"assets/assets/images/bullet3.png": "5df8113b6630b65abe9663311aa34b45",
"assets/assets/images/button_fire.png": "4ea97e5c68c86dfff093802f70690aa1",
"assets/assets/images/button_frizz.png": "0359c5043fd9726ce2f46540640dbd7d",
"assets/assets/images/button_speed.png": "4ac676bb190135c700bcd49e335ca00b",
"assets/assets/images/explosion0.png": "c9b40d00558543558db6d32904aa33ba",
"assets/assets/images/explosion1.png": "bc26ff4c3b0217bee0717269eab0a602",
"assets/assets/images/explosion2.png": "868e3fa1a6fc8f76f37b9b69de0834f9",
"assets/assets/images/explosion3.png": "5a11b29194a19e8072bce706d2feedf3",
"assets/assets/images/player0.png": "e9bf185d5f10df6b124d848c963f7208",
"assets/assets/images/player1.png": "a6807ceb2a8a58929d10ab5a77540c48",
"assets/assets/images/player2.png": "ba2e41b9f887f3365c4b3b4317c72368",
"assets/assets/images/player3.png": "4ad5554bdc8c4b77b2cc81b53f5ff008",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "62ec8220af1fb03e1c20cfa38781e17e",
"assets/google_fonts/PressStart2P-Regular.ttf": "f98cd910425bf727bd54ce767a9b6884",
"assets/NOTICES": "1c7add2c46e4ec4efddcd683592ce4a4",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "57d849d738900cfd590e9adc7e208250",
"assets/shaders/ink_sparkle.frag": "57f2f020e63be0dd85efafc7b7b25d80",
"canvaskit/canvaskit.js": "d8ad2fa33cb436ca011f6077f636fe31",
"canvaskit/canvaskit.wasm": "b8cab17884c5624ba035fdb63f9c9333",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "6b515e434cea20006b3ef1726d2c8894",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "ff46b5d2f26677c4f96b6b4642d3b6cf",
"/": "ff46b5d2f26677c4f96b6b4642d3b6cf",
"main.dart.js": "76e80b2b67bd5e1e769a5b180a05a597",
"manifest.json": "fea4ecd2f215e5cff6bdfec4d9e51012",
"version.json": "a9fc4810c39ff137ea6f0ac50a576291"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
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

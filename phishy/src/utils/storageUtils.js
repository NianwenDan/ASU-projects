export const ONE_HOUR = 60 * 60 * 1000;

export function sanitizeUrl(url) {
  const urlObj = new URL(url);

  return urlObj.origin + urlObj.pathname;
}

export function storeUrlStatus(url, unsafe, mlSafe = null) {
  const sanitizedUrl = sanitizeUrl(url);
  const data = { unsafe, mlSafe, timestamp: Date.now() };

  chrome.storage.local.set({ [sanitizedUrl]: data });
  pruneOldData();
}

export function pruneOldData() {
  chrome.storage.local.get(null, (items) => {
    const now = Date.now();
    const toRemove = [];

    for (const [url, data] of Object.entries(items)) {
      if (data.timestamp && now - data.timestamp > ONE_HOUR) {
        toRemove.push(url);
      }
    }

    if (toRemove.length > 0) {
      chrome.storage.local.remove(toRemove);
    }
  });
}

const ONE_HOUR = 60 * 60 * 1000;

const iframe = document.createElement("iframe");
iframe.src = chrome.runtime.getURL("sandbox/sandbox.html");
iframe.style.display = "none";
document.body.appendChild(iframe);

function runMLCheck(url) {
  return new Promise((resolve) => {
    const handleMessage = (event) => {
      if (event.data.type === "mlResult") {
        window.removeEventListener("message", handleMessage);
        resolve(event.data.result);
      }
    };

    window.addEventListener("message", handleMessage);

    const sandbox = document.querySelector('iframe[src*="sandbox.html"]');
    sandbox?.contentWindow?.postMessage({ type: "runML", url }, "*");
  });
}

function sanitizeUrl(url) {
  const urlObj = new URL(url);

  return urlObj.origin + urlObj.pathname;
}

function storeUrlStatus(url, unsafe, mlSafe) {
  const sanitizedUrl = sanitizeUrl(url);
  const data = { unsafe, mlSafe, timestamp: Date.now() };

  chrome.storage.local.set({ [sanitizedUrl]: data });
  pruneOldData();
}

function pruneOldData() {
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

function checkPolicies(url) {
  const sanitizedUrl = sanitizeUrl(url);

  for (const policy of blacklist) {
    const regex = new RegExp(policy.pattern);
    if (regex.test(sanitizedUrl)) {
      return {
        isBlocked: true,
        reason: `Blacklisted by rule ${policy.ruleId}`,
      };
    }
  }

  for (const policy of whitelist) {
    const regex = new RegExp(policy.pattern);
    if (regex.test(sanitizedUrl)) {
      return {
        isBlocked: false,
        reason: `Whitelisted by rule ${policy.ruleId}`,
      };
    }
  }

  return null;
}

function redirectToBlockedPage(sanitizedUrl) {
  const blockedUrl = chrome.runtime.getURL(
    `src/blocked/blocked.html?url=${encodeURIComponent(sanitizedUrl)}`
  );
  window.stop();
  window.location.replace(blockedUrl);
}

async function checkUrlWithPolicies(currentUrl) {
  const sanitizedUrl = sanitizeUrl(currentUrl);
  const policyResult = checkPolicies(currentUrl);

  if (policyResult) {
    if (policyResult.isBlocked) {
      redirectToBlockedPage(sanitizedUrl);
      return;
    } else {
      console.log(`Allowed: ${policyResult.reason}`);
      return;
    }
  }

  chrome.storage.local.get(sanitizedUrl, async (result) => {
    const storedData = result[sanitizedUrl];
    const now = Date.now();
    if (
      storedData &&
      storedData.timestamp &&
      now - storedData.timestamp <= ONE_HOUR
    ) {
      if (storedData.unsafe) {
        redirectToBlockedPage(sanitizedUrl);
      }
    } else {
      const apiPromise = new Promise((resolve) => {
        chrome.runtime.sendMessage(
          { type: "checkUrl", url: sanitizedUrl },
          (response) => {
            if (!response?.error) {
              resolve(response.unsafe);
            } else {
              console.error("API check failed:", response?.error);
              resolve(false); // fail open
            }
          }
        );
      });

      // Run ML check
      const mlPromise = runMLCheck(sanitizedUrl).then((res) => res !== 1n);

      const [apiResult, mlResult] = await Promise.all([apiPromise, mlPromise]);
      console.log("apiResult, mlResult", apiResult, mlResult);

      const isUnsafe = apiResult || mlResult;

      if (isUnsafe) {
        storeUrlStatus(sanitizedUrl, apiResult, !mlResult);
        redirectToBlockedPage(sanitizedUrl);
      } else {
        storeUrlStatus(sanitizedUrl, false, true);
      }
    }
  });
}

const currentUrl = window.location.href;

chrome.storage.local.get(["whitelist", "blacklist"], (result) => {
  whitelist = Array.isArray(result.whitelist)
    ? [...result.whitelist]
    : Object.values(result.whitelist || {});

  blacklist = Array.isArray(result.blacklist)
    ? [...result.blacklist]
    : Object.values(result.blacklist || {});

  checkUrlWithPolicies(currentUrl);
});

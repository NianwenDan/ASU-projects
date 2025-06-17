<template>
  <div class="popup" v-if="isDataLoaded">
    <n-space vertical align="start">
      <h3 v-if="isWhitelisted || isBlacklisted">{{ listedStatusMessage }}</h3>
      <template v-else>
        <h3 v-for="(msg, label) in statusMessage" :key="label">
          {{ label }}: {{ msg }}
        </h3>
      </template>
      <p class="url-text">URL: {{ sanitizedUrl }}</p>
      <n-space align="start" wrap>
        <n-button
          v-if="showRecheck"
          type="info"
          size="small"
          @click="recheckUrl"
          :disabled="loading"
          >Recheck</n-button
        >
        <n-button
          v-if="showAllow"
          type="success"
          size="small"
          @click="alwaysAllow"
          >Always Allow</n-button
        >
        <n-button
          v-if="showBlock"
          type="warning"
          size="small"
          @click="blockSite"
          >Block</n-button
        >
        <n-button
          v-if="showRemoveAllow"
          type="default"
          size="small"
          @click="removeFromAllow"
          >Remove from Allow</n-button
        >
        <n-button
          v-if="showRemoveBlock"
          type="default"
          size="small"
          @click="removeFromBlock"
          >Remove from Block</n-button
        >
        <n-button type="default" size="small" @click="openSettings">
          Settings
        </n-button>
      </n-space>
    </n-space>
  </div>
  <div v-else class="loading">Loading...</div>
</template>

<script>
import { NSpace, NButton } from "naive-ui";
import {
  storeUrlStatus,
  pruneOldData,
  sanitizeUrl,
} from "../utils/storageUtils.js";

export default {
  components: {
    NSpace,
    NButton,
  },
  data() {
    return {
      url: "",
      sanitizedUrl: "",
      statusMessage: {
        "API Check": "Checking URL...",
        "ML Check": "Checking URL...",
      },
      listedStatusMessage: "",
      unsafe: false,
      loading: true,
      isWhitelisted: false,
      isBlacklisted: false,
      isDataLoaded: false,
      whitelist: [],
      blacklist: [],
    };
  },
  computed: {
    showRecheck() {
      return !this.isWhitelisted && !this.isBlacklisted;
    },
    showAllow() {
      return !this.isWhitelisted && !this.isBlacklisted;
    },
    showBlock() {
      return !this.isWhitelisted && !this.isBlacklisted;
    },
    showRemoveAllow() {
      return this.isWhitelisted;
    },
    showRemoveBlock() {
      return this.isBlacklisted;
    },
  },
  methods: {
    checkPolicies(url) {
      const sanitizedUrl = this.sanitizedUrl || sanitizeUrl(url);
      for (const policy of this.blacklist) {
        const regex = new RegExp(policy.pattern);
        if (regex.test(sanitizedUrl)) {
          return { isBlocked: true, ruleId: policy.ruleId };
        }
      }
      for (const policy of this.whitelist) {
        const regex = new RegExp(policy.pattern);
        if (regex.test(sanitizedUrl)) {
          return { isBlocked: false, ruleId: policy.ruleId };
        }
      }
      return null;
    },
    checkUrl() {
      this.loading = true;
      const sanitizedUrl = this.sanitizedUrl || sanitizeUrl(this.url);
      const policyResult = this.checkPolicies(this.url);

      if (policyResult) {
        if (policyResult.isBlocked) {
          this.listedStatusMessage = "Blocked URL";
          this.isBlacklisted = true;
        } else {
          this.listedStatusMessage = "Allowed URL";
          this.isWhitelisted = true;
        }
        this.loading = false;
      } else {
        const iframe = document.querySelector('iframe[src*="sandbox.html"]');
        iframe.contentWindow.postMessage(
          { type: "runML", url: sanitizedUrl },
          "*"
        );

        window.addEventListener("message", (event) => {
          if (event.data.type === "mlResult") {
            const mlSafe = event.data.result !== 1n;
            console.log(event.data.result);
            this.statusMessage["ML Check"] = mlSafe ? "✅" : "‼️";
            storeUrlStatus(this.sanitizedUrl, this.isSafe, !mlSafe);
          }
        });

        chrome.runtime.sendMessage(
          { type: "checkUrl", url: sanitizedUrl },
          (response) => {
            if (response && !response.error) {
              this.isSafe = !response.unsafe;
              this.statusMessage["API Check"] = this.isSafe ? "✅" : "‼️";
              storeUrlStatus(
                sanitizedUrl,
                this.isSafe,
                this.statusMessage["ML Check"] === "✅"
              );
            } else {
              this.statusMessage = "Error checking URL";
              console.error("API check failed:", response?.error);
            }
            this.loading = false;
          }
        );
      }
      pruneOldData();
    },
    recheckUrl() {
      this.loading = true;
      this.checkUrl();
    },
    alwaysAllow() {
      const sanitizedUrl = this.sanitizedUrl || sanitizeUrl(this.url);
      const newPolicy = {
        ruleId: this.generateRandomString(),
        pattern: sanitizedUrl,
        action: ["Allow"],
      };
      this.whitelist.push(newPolicy);
      chrome.storage.local.set({ whitelist: this.whitelist }, () => {
        this.isWhitelisted = true;
        this.statusMessage = "Allowed URL";
      });
    },
    blockSite() {
      const sanitizedUrl = this.sanitizedUrl || sanitizeUrl(this.url);
      const newPolicy = {
        ruleId: this.generateRandomString(),
        pattern: sanitizedUrl,
        action: ["Deny"],
      };
      this.blacklist.push(newPolicy);
      chrome.storage.local.set({ blacklist: this.blacklist }, () => {
        this.isBlacklisted = true;
        this.statusMessage = "Blocked URL";
      });
    },
    removeFromAllow() {
      const sanitizedUrl = this.sanitizedUrl || sanitizeUrl(this.url);
      this.whitelist = this.whitelist.filter(
        (policy) => !new RegExp(policy.pattern).test(sanitizedUrl)
      );
      chrome.storage.local.set({ whitelist: this.whitelist }, () => {
        this.isWhitelisted = false;
        this.checkUrl();
      });
    },
    removeFromBlock() {
      const sanitizedUrl = this.sanitizedUrl || sanitizeUrl(this.url);
      this.blacklist = this.blacklist.filter(
        (policy) => !new RegExp(policy.pattern).test(sanitizedUrl)
      );
      chrome.storage.local.set({ blacklist: this.blacklist }, () => {
        this.isBlacklisted = false;
        this.checkUrl();
      });
    },
    generateRandomString(length = 6) {
      const chars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      let result = "";
      for (let i = 0; i < length; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
      }
      return result;
    },
    openSettings() {
      chrome.windows.create({
        url: chrome.runtime.getURL("src/settings/settings.html"),
        type: "popup",
        width: 400,
        height: 300,
      });
    },
  },
  mounted() {
    const iframe = document.createElement("iframe");
    iframe.src = chrome.runtime.getURL("sandbox/sandbox.html");
    iframe.style.display = "none";

    document.body.appendChild(iframe);

    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      this.url = tabs[0].url;
      this.sanitizedUrl = sanitizeUrl(this.url);

      chrome.storage.local.get([this.sanitizedUrl], (result) => {
        const stored = result[this.sanitizedUrl];
        if (stored) {
          if (typeof stored.unsafe === "boolean") {
            this.statusMessage["API Check"] = !stored.unsafe ? "✅" : "‼️";
          }
          if (typeof stored.mlSafe === "boolean") {
            this.statusMessage["ML Check"] = stored.mlSafe ? "✅" : "‼️";
          }
        }
      });

      chrome.storage.local.get(["whitelist", "blacklist"], (result) => {
        this.whitelist = Array.isArray(result.whitelist)
          ? [...result.whitelist]
          : Object.values(result.whitelist || {});

        this.blacklist = Array.isArray(result.blacklist)
          ? [...result.blacklist]
          : Object.values(result.blacklist || {});

        this.isDataLoaded = true;
        this.checkUrl();
      });
    });
  },
};
</script>

<style scoped>
.popup {
  width: 300px;
  padding: 16px;
  font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
  background: #ffffff;
  border-radius: 8px;
}

h3 {
  margin: 0 0 8px;
  font-size: 16px;
  color: #333;
  text-align: left;
}

.url-text {
  font-size: 12px;
  color: #666;
  word-break: break-all;
  text-align: left;
  margin: 0 0 12px;
}

.n-button {
  border-radius: 4px;
  transition: transform 0.2s ease;
}

.n-button:hover {
  transform: scale(1.05);
}

.n-button--success {
  background-color: #18a058;
}

.n-button--warning {
  background-color: #d93025;
}

.n-button--info {
  background-color: #096dd9;
}

.n-space {
  padding: 0;
}
</style>

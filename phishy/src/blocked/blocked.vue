<template>
  <header>
    <img src="/icons/phishy-128.png" alt="logo">
  </header>
  <main>
    <div class="terminal">
      <p><span class="green-color">warning&#64;phishy ></span> ./phishy</p>
      <p>
        <span class="oragne-color">PHISHY CHROME EXTENSION WARNING</span>:
        "<span class="red-color">This website has been blocked</span>"
      </p>
      <p>
        <span class="oragne-color">DESCRIPTION</span>: "<span class="red-color"
          >You are attempting to visit a website identified as unsafe. Our
          AI-powered detection system has classified this page as a phishing
          threat.</span
        >"
      </p>
      <p><span class="oragne-color">WEBSITE NAME</span>: {{ websiteName }}</p>
      <p><span class="oragne-color">WEBSITE LINK</span>: {{ websiteUrl }}</p>
      <p>
        If you believe this is a mistake, please report it and add to the
        whitelist.
      </p>
      <p><span class="green-color">warning&#64;phishy ></span></p>
      <p>
        <span class="green-color">warning&#64;phishy ></span> ./{{ userSelectedOption }}
      </p>

      <div class="options">
        <button @click="placeToWhitelist">Place to Whitelist</button>
        <button @click="goToSettings">Go to Phishy Settings</button>
      </div>
    </div>
  </main>
</template>

<script>
export default {
  data() {
    return {
      websiteName: "Unknown",
      websiteUrl: "Unknown",
      userSelectedOption: "",
    };
  },
  mounted() {
    const params = new URLSearchParams(window.location.search);
    this.websiteName = params.get("name") || "Unknown";
    this.websiteUrl = params.get("url") || "Unknown";
  },
  methods: {
    placeToWhitelist() {
      chrome.storage.local.get(["whitelist"], (result) => {
        const whitelist = Array.isArray(result.whitelist)
          ? [...result.whitelist]
          : Object.values(result.whitelist || {});

        const ruleId = Math.random().toString(36).slice(2, 10);
        const newEntry = {
          ruleId,
          pattern: this.websiteUrl,
          action: ["Allow"],
        };
        whitelist.push(newEntry);

        chrome.storage.local.set({ whitelist }, () => {
          window.location.href = this.websiteUrl;
        });
      });
    },

    goToSettings() {
      const settingsUrl = chrome.runtime.getURL("src/settings/settings.html");
      window.location.href = settingsUrl;
    },
  },
};
</script>
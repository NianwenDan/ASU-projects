<script>
import { NButton, NSpace, NSwitch, NForm, NFormItem, NInput } from "naive-ui";

export default {
  name: "General",
  components: { NSpace, NSwitch, NButton, NForm, NFormItem, NInput },
  data() {
    return {
      generalSettings: {
        isActiveApiKey: false,
        googleSafeBrowsingApiKey: "",
      },
    };
  },
  watch: {
    "generalSettings.isActiveApiKey"(newValue) {
      if (!newValue) {
        this.generalSettings.googleSafeBrowsingApiKey = "";
      }
      this.saveSettings();
    },
    "generalSettings.googleSafeBrowsingApiKey"() {
      this.saveSettings();
    },
  },
  methods: {
    loadSettings() {
      chrome.storage.local.get(["generalSettings"], (result) => {
        if (result.generalSettings) {
          this.generalSettings = {
            ...this.generalSettings,
            ...result.generalSettings,
          };
        }
      });
    },
    saveSettings() {
      chrome.storage.local.set({
        generalSettings: {
          isActiveApiKey: this.generalSettings.isActiveApiKey,
          googleSafeBrowsingApiKey:
            this.generalSettings.googleSafeBrowsingApiKey,
        },
      });
    },
    exportSettings() {
      chrome.storage.local.get(["whitelist", "blacklist"], (result) => {
        const settings = {
          whitelist: Array.isArray(result.whitelist)
            ? [...result.whitelist]
            : Object.values(result.whitelist || {}),
          blacklist: Array.isArray(result.blacklist)
            ? [...result.blacklist]
            : Object.values(result.blacklist || {}),
        };

        const jsonString = JSON.stringify(settings, null, 2);
        const blob = new Blob([jsonString], { type: "application/json" });
        const url = URL.createObjectURL(blob);
        const link = document.createElement("a");

        link.href = url;
        link.download = `phishy-settings-${
          new Date().toISOString().split("T")[0]
        }.json`;
        document.body.appendChild(link);
        link.click();

        document.body.removeChild(link);
        URL.revokeObjectURL(url);
      });
    },
  },
  mounted() {
    this.loadSettings();
  },
};
</script>

<template>
  <h3>External API Key Configuration</h3>
  <p class="setting-description">
    Enable this option to use a third-party API for phishing website detection.
    When activated, website URLs will be sent to the selected external service
    for real-time analysis. This may improve detection accuracy but could
    involve sharing browsing data with the API provider.
  </p>
  <n-form>
    <n-form-item label="Enable External API Usage: ">
      <n-switch v-model:value="generalSettings.isActiveApiKey" />
    </n-form-item>

    <n-form-item
      v-if="generalSettings.isActiveApiKey"
      label="Google Safe Browsing API Key:"
    >
      <n-input
        v-model:value="generalSettings.googleSafeBrowsingApiKey"
        type="text"
      />
    </n-form-item>
  </n-form>

  <h3>Export Configuration Settings</h3>
  <p class="setting-description">
    Use this option to download and save your current plugin settings. This
    allows you to back up your configuration or transfer it to another device
    easily. Settings will be exported as a file for future import.
  </p>
  <n-space>
    <n-button @click="exportSettings">Export Policies</n-button>
    <!-- TODO: Implement import button -->
    <!-- <n-button>Import</n-button> -->
  </n-space>
</template>

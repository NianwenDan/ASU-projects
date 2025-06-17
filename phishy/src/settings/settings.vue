<template>
  <n-config-provider>
    <BaseLayout>
      <template v-slot:header>
        <setting-header></setting-header>
      </template>
      <template v-slot:content>
        <setting-content></setting-content>
      </template>
    </BaseLayout>
  </n-config-provider>
</template>

<script>
import BaseLayout from "@/settings/layout/BaseLayout.vue";
import SettingHeader from "@/settings/components/Header.vue";
import SettingContent from "@/settings/components/Content.vue";
import { NConfigProvider } from "naive-ui";

export default {
  name: "App",
  components: {
    BaseLayout,
    SettingHeader,
    SettingContent,
    NConfigProvider,
  },
};
</script>

<style scoped></style>

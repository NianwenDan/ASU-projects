<template>
  <div
    v-for="item in menuItems"
    :key="item.name"
    :class="['menu-item', { active: activeMenuItem === item.name }]"
    @click="setActiveMenuItem(item.name)"
  >
    <div class="menu-icon" :style="{ backgroundColor: item.iconBg }">
      <n-icon
        size="18"
        color="white"
        :component="getIcon(item.iconName)"
      ></n-icon>
    </div>
    <span>{{ item.label }}</span>
  </div>
</template>

<script>
import { NIcon } from "naive-ui";
import {
  CloseOutline,
  SettingsOutline,
  ShieldCheckmarkOutline,
  DocumentTextOutline,
  InformationCircleOutline,
} from "@vicons/ionicons5";

export default {
  name: "SettingSidebar",
  props: ["activeMenuItem", "menuItems", "setActiveMenuItem"],
  components: {
    NIcon,
  },
  methods: {
    getIcon(iconName) {
      if (!iconName) {
        return CloseOutline;
      }
      const predefinedIcon = {
        SettingsOutline: SettingsOutline,
        ShieldCheckmarkOutline: ShieldCheckmarkOutline,
        DocumentTextOutline: DocumentTextOutline,
        InformationCircleOutline: InformationCircleOutline,
      };
      return predefinedIcon[iconName];
    },
  },
};
</script>
<style scoped>
.menu-item {
  display: flex;
  align-items: center;
  padding: 12px 15px;
  border-radius: 7px;
  margin-top: 3px;
  cursor: pointer;
  gap: 12px;
  transition: background-color 0.2s;
}

.menu-item:hover {
  background-color: rgba(0, 0, 0, 0.15);
}

.menu-item.active {
  background-color: rgba(0, 0, 0, 0.15);
}

.menu-icon {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>

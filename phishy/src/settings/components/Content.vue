<template>
  <ContentLayout>
    <template v-slot:sidebar>
      <setting-sidebar
        :active-menu-item="activeMenuItem"
        :menu-items="menuItems"
        :set-active-menu-item="setActiveMenuItem"
      >
      </setting-sidebar>
    </template>
    <template v-slot:main-content-label>{{ getActiveMenuLabel }}</template>
    <template v-slot:main-content>
      <component :is="activeMenuItem"></component>
    </template>
  </ContentLayout>
</template>

<script>
import SettingSidebar from "@/settings/components/Sidebar.vue";
import ContentLayout from "@/settings/layout/ContentLayout.vue";
import General from "@/settings/components/MainContent/General.vue";
import Security from "@/settings/components/MainContent/Security.vue";
// import Audit from "@/settings/components/MainContents/Audit.vue"; TODO: Implement Auditing
import About from "@/settings/components/MainContent/About.vue";

export default {
  name: "setting-content",
  components: {
    General,
    Security,
    // Audit, TODO: Implement Auditing
    About,
    ContentLayout,
    SettingSidebar,
  },
  data() {
    return {
      activeMenuItem: "general",
      menuItems: [
        {
          name: "general",
          label: "General",
          iconBg: "#54B4FF",
          iconName: "SettingsOutline",
        },
        {
          name: "security",
          label: "Security",
          iconBg: "#F5A623",
          iconName: "ShieldCheckmarkOutline",
        },
        // {name: "audit", label: "Audit", iconBg: "#4CD964", iconName: 'DocumentTextOutline'}, TODO: Implement Auditing
        {
          name: "about",
          label: "About",
          iconBg: "#9E9E9E",
          iconName: "InformationCircleOutline",
        },
      ],
    };
  },
  methods: {
    setActiveMenuItem(menuName) {
      this.activeMenuItem = menuName;
    },
  },
  computed: {
    getActiveMenuLabel() {
      for (const menuItem of this.menuItems) {
        if (this.activeMenuItem === menuItem.name) {
          return menuItem.label;
        }
      }
      return "Failed to Find Current Active Label";
    },
  },
};
</script>

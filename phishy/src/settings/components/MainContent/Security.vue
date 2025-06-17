<script>
import {
  NDataTable,
  NButton,
  NSpace,
  NModal,
  NForm,
  NFormItem,
  NInput,
  NSelect,
  NTag,
  NButtonGroup,
} from "naive-ui";
import { h } from "vue";

export default {
  name: "Security",
  components: {
    NInput,
    NFormItem,
    NForm,
    NSelect,
    NDataTable,
    NButton,
    NSpace,
    NModal,
    NTag,
    NButtonGroup,
  },
  data() {
    return {
      currentView: "blacklist", // "blacklist", "whitelist", or "all"
      isConfirmDeleteVisible: false, // For policy delete (security tab)
      policyToDelete: null, // For policy delete (security tab)
      searchKeyword: "", // (For filter)
      searchFilter: "ruleId", // (For filter) default to ruleId
      actionSortOrder: null, // (For sort) default to null
      securitySettings: {
        isShowCreatePolicy: false,
        createPolicy: {
          bodyStyle: {
            width: "600px",
          },
          ruleId: this.generateRandomString(),
          pattern: "",
          action: "",
          actionOptions: [
            { label: "Allow", value: "Allow" },
            { label: "Deny", value: "Deny" },
          ],
        },
      },
      tableColumns: [
        // added
        { title: "Rule ID", key: "ruleId" },
        { title: "Pattern", key: "pattern" },
        {
          title: () =>
            this.currentView === "all"
              ? h(
                  "div",
                  { style: "display: flex; align-items: center; gap: 6px;" },
                  [
                    "Action",
                    h(NSelect, {
                      size: "small",
                      value: this.actionSortOrder,
                      placeholder: "Sort actions",
                      options: [
                        { label: "Allow First", value: "Allow" },
                        { label: "Deny First", value: "Deny" },
                        { label: "Reset Sort", value: null },
                      ],
                      style: "width: 110px;",
                      onUpdateValue: (val) => (this.actionSortOrder = val),
                    }),
                  ]
                )
              : "Action",
          key: "action",
          render(row) {
            return row.action.map((tagKey) =>
              h(
                NTag,
                {
                  style: { marginRight: "12px" },
                  type: tagKey === "Allow" ? "success" : "error",
                  bordered: false,
                },
                { default: () => tagKey }
              )
            );
          },
        },
        {
          title: "Manage",
          key: "actions",
          render: (row) =>
            h(
              NButton,
              {
                size: "small",
                type: "error",
                onClick: () => this.confirmDelete(row),
              },
              { default: () => "Delete" }
            ),
        },
      ],
      blacklistData: [],
      whitelistData: [],
    };
  },
  // Filter logic: return search key from the searching box & sorting (Allow:Deny) on View all tab(next to 'Action')
  computed: {
    filteredData() {
      const keyword = this.searchKeyword.trim().toLowerCase();
      const baseData =
        this.currentView === "blacklist"
          ? this.blacklistData
          : this.currentView === "whitelist"
          ? this.whitelistData
          : [...this.blacklistData, ...this.whitelistData];

      const filtered = keyword
        ? baseData.filter((item) =>
            item[this.searchFilter]?.toLowerCase().includes(keyword)
          )
        : baseData;

      if (this.actionSortOrder === "Allow") {
        return filtered.sort((a, b) => {
          const aVal = a.action.includes("Allow") ? 0 : 1;
          const bVal = b.action.includes("Allow") ? 0 : 1;
          return aVal - bVal;
        });
      }

      if (this.actionSortOrder === "Deny") {
        return filtered.sort((a, b) => {
          const aVal = a.action.includes("Deny") ? 0 : 1;
          const bVal = b.action.includes("Deny") ? 0 : 1;
          return aVal - bVal;
        });
      }

      return filtered;
    },
  },
  methods: {
    async loadPolicies() {
      chrome.storage.local.get(["whitelist", "blacklist"], (result) => {
        if (!result.whitelist && !result.blacklist) {
          chrome.storage.local.set({
            whitelist: [],
            blacklist: [],
          });
        }
        this.whitelistData = Array.isArray(result.whitelist)
          ? [...result.whitelist]
          : Object.values(result.whitelist || {});
        this.blacklistData = Array.isArray(result.blacklist)
          ? [...result.blacklist]
          : Object.values(result.blacklist || {});

        this.whitelistData.forEach((item) => {
          item.action = Object.values(item.action);
        });

        this.blacklistData.forEach((item) => {
          item.action = Object.values(item.action);
        });
      });
    },

    async savePolicies() {
      chrome.storage.local.set({
        whitelist: [...this.whitelistData],
        blacklist: [...this.blacklistData],
      });
    },

    addNewPolicy() {
      const newPolicy = {
        ruleId: this.securitySettings.createPolicy.ruleId,
        pattern: this.securitySettings.createPolicy.pattern,
        action: [this.securitySettings.createPolicy.action],
      };

      // modified logic to push into the correct list
      if (newPolicy.action.includes("Deny")) {
        this.blacklistData.push(newPolicy);
      } else {
        this.whitelistData.push(newPolicy);
      }
      this.savePolicies();
      this.securitySettings.isShowCreatePolicy = false;
      this.securitySettings.createPolicy.ruleId = this.generateRandomString();
      this.securitySettings.createPolicy.pattern = "";
      this.securitySettings.createPolicy.action = "";
    },

    // Policy(row) deletion logic
    // Confirm Delete Setup
    confirmDelete(row) {
      this.policyToDelete = row;
      this.isConfirmDeleteVisible = true;
    },
    // Perform the deletion on the dialog (modal)
    performDelete() {
      const list = this.policyToDelete.action.includes("Deny")
        ? this.blacklistData
        : this.whitelistData;
      const index = list.findIndex(
        (item) => item.ruleId === this.policyToDelete.ruleId
      );
      if (index !== -1) list.splice(index, 1);

      this.savePolicies();
      this.cancelDelete();
    },
    // Cancel the deletion on modal
    cancelDelete() {
      this.isConfirmDeleteVisible = false;
      this.policyToDelete = null;
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
  },
  mounted() {
    this.loadPolicies();
  },
};
</script>

<template>
  <h3></h3>
  <!-- Filter & search bar -->
  <div
    style="margin-bottom: 16px; display: flex; gap: 12px; align-items: center"
  >
    <n-select
      v-model:value="searchFilter"
      :options="[
        { label: 'Filter by Rule ID', value: 'ruleId' },
        { label: 'Filter by Pattern', value: 'pattern' },
      ]"
      style="width: 160px"
      placeholder="Select Filter"
    />
    <n-input
      v-model:value="searchKeyword"
      placeholder="Search..."
      clearable
      style="flex: 1"
    />
  </div>

  <!-- added buttons to switch views -->
  <!-- Table with control group on the right side -->
  <div style="display: flex; gap: 20px; align-items: flex-start">
    <n-data-table
      style="flex: 1"
      :single-line="false"
      :columns="tableColumns"
      :data="filteredData"
      :pagination="{ pageSize: 10 }"
    />
    <!-- Button group: Right side of the table -->
    <n-button-group
      vertical
      style="
        border-radius: 14px;
        overflow: hidden;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
      "
    >
      <n-button
        class="hover-button"
        :type="currentView === 'blacklist' ? 'primary' : 'default'"
        @click="currentView = 'blacklist'"
        >Blacklist</n-button
      >
      <n-button
        class="hover-button"
        :type="currentView === 'whitelist' ? 'primary' : 'default'"
        @click="currentView = 'whitelist'"
        >Whitelist</n-button
      >
      <n-button
        class="hover-button"
        :type="currentView === 'all' ? 'primary' : 'default'"
        @click="currentView = 'all'"
        >View All</n-button
      >
    </n-button-group>
  </div>

  <!-- Bottom-left: Create & Import policy buttons -->
  <div style="display: flex; justify-content: flex-start; margin-top: 12px">
    <n-space>
      <n-button
        class="hover-button-with-black"
        @click="securitySettings.isShowCreatePolicy = true"
        >Create Policy</n-button
      >
      <!-- TODO: Implement Import Button -->
      <!-- <n-button class="hover-button-with-black">Import Policy</n-button> -->
    </n-space>
  </div>

  <n-modal
    v-model:show="securitySettings.isShowCreatePolicy"
    :mask-closable="true"
    :bordered="true"
    preset="card"
    title="Create Policy"
    :style="securitySettings.createPolicy.bodyStyle"
  >
    <n-form ref="formRef">
      <n-form-item label="Rule Id: ">
        <n-input
          v-model:value="securitySettings.createPolicy.ruleId"
          type="text"
          disabled
        />
      </n-form-item>

      <n-form-item label="Pattern: ">
        <n-input
          v-model:value="securitySettings.createPolicy.pattern"
          type="text"
          clearable
        />
      </n-form-item>

      <n-form-item label="Action: ">
        <n-select
          v-model:value="securitySettings.createPolicy.action"
          :options="securitySettings.createPolicy.actionOptions"
        />
      </n-form-item>

      <n-form-item>
        <n-button @click.prevent="addNewPolicy">Save</n-button>
      </n-form-item>
    </n-form>
  </n-modal>
  <!-- Deletion pop up window: confirm delete or cancel (remain unchange) -->
  <n-modal
    v-model:show="isConfirmDeleteVisible"
    preset="dialog"
    :title="`Warning: Delete Policy ${policyToDelete?.ruleId || ''}?`"
  >
    <template #default>
      <ul style="margin-top: 10px; padding-left: 20px; line-height: 1.6">
        <li><strong>Rule ID:</strong> {{ policyToDelete?.ruleId }}</li>
        <li><strong>Pattern:</strong> {{ policyToDelete?.pattern }}</li>
        <li>
          <strong>Action:</strong> {{ policyToDelete?.action?.join(", ") }}
        </li>
      </ul>
    </template>

    <template #action>
      <n-space justify="end">
        <n-button secondary @click="cancelDelete">Cancel</n-button>
        <n-button type="error" @click="performDelete">Confirm Delete</n-button>
      </n-space>
    </template>
  </n-modal>
</template>

<!-- Bottom-left: Create & Import policy buttons -->
<style scoped>
.hover-button-with-black {
  background-color: black;
  color: white;
  transition: all 0.3s ease;
  border-radius: 6px;
}

.hover-button-with-black:hover {
  transform: scale(1.05);
  border-radius: 12px;
}

:deep(.hover-button) {
  transition: all 0.3s ease;
  border-radius: 6px;
}

:deep(.hover-button:hover) {
  transform: scale(1.05);
  border-radius: 12px;
}
</style>

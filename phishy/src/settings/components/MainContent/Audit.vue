<script>
import {
  NDataTable,
  NSwitch,
  NForm,
  NFormItem,
  NInput,
  NInputNumber,
} from "naive-ui";
export default {
  name: "Audit",
  components: {
    NSwitch,
    NDataTable,
    NForm,
    NFormItem,
    NInput,
    NInputNumber,
  },
  data() {
    return {
      auditSettings: {
        isActive: false,
        auditLimit: 100,
        auditIdFilter: "",
      },
      auditDataTable: {
        pagination: {
          pageSize: 5,
        },
        data: [
          {
            auditId: "AUD-2001",
            time: "2025-03-24T08:12:45Z",
            blockedUrl: "http://malicious-site.com/phishing",
          },
          {
            auditId: "AUD-2002",
            time: "2025-03-24T09:01:17Z",
            blockedUrl: "http://suspiciousdownload.net/file.exe",
          },
          {
            auditId: "AUD-2003",
            time: "2025-03-24T09:45:33Z",
            blockedUrl: "http://unsecure-connection.org/login",
          },
          {
            auditId: "AUD-2004",
            time: "2025-03-24T10:22:09Z",
            blockedUrl: "http://ads-popup.biz/clickme",
          },
          {
            auditId: "AUD-2005",
            time: "2025-03-24T10:59:40Z",
            blockedUrl: "http://fake-update-alert.com",
          },
          {
            auditId: "AUD-2006",
            time: "2025-03-25T10:59:40Z",
            blockedUrl: "http://a.fake-update-alert.com",
          },
        ],
        columns: [
          {
            title: "Audit Id",
            key: "auditId",
            filter(value, row) {
              return row.auditId.includes(value);
            },
          },
          { title: "Time", key: "time" },
          { title: "Blocked Url", key: "blockedUrl" },
        ],
      },
    };
  },
  methods: {
    filterAuditId() {
      const inputValue = this.auditSettings.auditIdFilter.trim();
      if (inputValue) {
        this.$refs.table.filter({
          auditId: [inputValue],
        });
      } else {
        this.$refs.table.filter(null); // clear filter if input is empty
      }
    },
  },
};
</script>

<template>
  <p class="setting-description">
    Keep track of the plugin’s activity with logged events, including detections
    and blocked URLs. Use this section to monitor actions and manage audit
    history.
  </p>
  <n-form label-width="auto">
    <n-form-item label="Enable Audit Logs: ">
      <n-switch v-model:value="auditSettings.isActive" />
    </n-form-item>

    <n-form-item v-if="auditSettings.isActive" label="Audit Retention Limit: ">
      <n-input-number
        v-model:value="auditSettings.auditLimit"
        :min="1"
        :max="5000"
      />
    </n-form-item>
  </n-form>

  <h3 v-if="auditSettings.isActive">Audit Logs</h3>
  <n-form
    v-if="auditSettings.isActive"
    :style="{
      maxWidth: '240px',
    }"
  >
    <n-form-item label="Search By Audit Id: ">
      <n-input
        v-model:value="auditSettings.auditIdFilter"
        type="text"
        placeholder="AUD-2001"
        @input="filterAuditId"
        clearable
      />
    </n-form-item>
  </n-form>

  <div v-if="auditSettings.isActive">
    <n-data-table
      ref="table"
      :single-line="false"
      :columns="auditDataTable.columns"
      :data="auditDataTable.data"
      :pagination="auditDataTable.pagination"
    />
  </div>
</template>

<style scoped></style>

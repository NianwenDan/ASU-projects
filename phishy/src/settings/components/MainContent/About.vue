<script>
export default {
  name: "About",
  data() {
    return {
      version: "1.0",
    };
  },
};
</script>

<template>
  <div class="setting-item">
    <div class="setting-title">
      Phishy browser extension version {{ version }}
    </div>
  </div>
</template>

<script>
export default {
  name: "ContentLayout",
};
</script>

<template>
  <div class="sidebar">
    <slot name="sidebar"></slot>
  </div>
  <div class="main-content">
    <h2>
      <slot name="main-content-label">No Main Content Label</slot>
    </h2>
    <slot name="main-content">No Main Content Added Yet!</slot>
  </div>
</template>

<style scoped>
.sidebar {
  width: 25%;
  padding: 10px 0 10px 10px;
}
.main-content {
  flex: 1;
  padding: 20px 30px;
}
</style>

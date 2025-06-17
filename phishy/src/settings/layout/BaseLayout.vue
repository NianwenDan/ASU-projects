<script>
export default {
  name: "BaseLayout",
};
</script>

<template>
  <div class="app-container">
    <div class="settings-container">
      <header>
        <slot name="header">No Header</slot>
      </header>

      <main>
        <slot name="content"></slot>
      </main>
    </div>
  </div>
</template>

<style scoped>
.app-container {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen,
    Ubuntu, Cantarell, sans-serif;
  max-width: 1100px;
  margin: 35px auto 0;
}

.settings-container {
  overflow: hidden;
}
header {
  display: flex;
  align-items: center;
  padding: 20px;
  gap: 15px;
  margin-bottom: 30px;
}
main {
  display: flex;
  min-height: 500px;
}
</style>

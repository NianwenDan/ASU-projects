<template>
  <div id="logo">
    <n-avatar round :size="100" src="../../icons/phishy-128.png"> </n-avatar>
  </div>
  <div class="title-container">
    <h1>Phishy Extension Settings</h1>
    <p>Customize how the Phishy extension works in your browser.</p>
  </div>
</template>

<script>
import { NAvatar } from "naive-ui";

export default {
  name: "setting-header",
  components: {
    NAvatar,
  },
};
</script>
<style scoped>
h1 {
  font-weight: 500;
  margin: 0;
}

h1 + p {
  font-size: 14px;
  color: #666;
  margin: 5px 0 0 0;
}

#logo {
  border-radius: 50%;
  width: 100px;
  height: 100px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.title-container {
  flex: 1;
}
</style>

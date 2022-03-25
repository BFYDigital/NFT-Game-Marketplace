<template>
  <div className="loading-overlay">
    <div className="overlay-inner">
      <Spinner />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import Spinner from "./Spinner.vue";

export default defineComponent({
  components: {
    Spinner,
  },
});
</script>

<style scoped>
.loading-overlay {
  position: fixed;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.2);
  z-index: 999;
}

.loading-overlay .overlay-inner {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  -ms-transform: translate(-50%, -50%);
}
</style>

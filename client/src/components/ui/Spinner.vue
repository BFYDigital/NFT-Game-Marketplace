<template>
  <div :class="class" role="status">
    <span class="visually-hidden">Loading...</span>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  props: {
    class: {
      type: String,
      default: "spinner-border spinner-border-sm",
    },
  },
});
</script>
<template>
  <canvas height="300" width="224" ref="canvasRef"></canvas>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import ZombieBuilder from "nft-zombies/client/src/utils/lib/ZombieBuilder";

export default defineComponent({
  props: {
    dna: String,
  },
  mounted: function () {
    const context = this.$refs.canvasRef.getContext("2d");
    if (context) {
      let zombieBuilder = new ZombieBuilder(this.dna, context);
      zombieBuilder.build();
    }
  },
});
</script>

<style scoped>
canvas {
  padding: 0 15px;
}
</style>
<template>
  <section id="hero" class="d-flex align-items-center">
    <div class="container position-relative">
      <div class="row justify-content-center">
        <div class="col-xl-7 col-lg-9 text-center">
          <h1>{{ title }}</h1>
          <h2>{{ subtitle }}</h2>
        </div>
      </div>
      <div class="text-center">
        <a
          @click.prevent="emitButtonClick"
          href="#"
          class="btn-get-started scrollto"
          >{{ buttonText }}</a
        >
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  props: {
    title: String,
    subtitle: String,
    buttonText: String,
  },
  methods: {
    emitButtonClick: function () {
      this.$emit("buttonClicked");
    },
  },
});
</script>

<style scoped>
#hero .container {
  padding-top: 40px;
}

#hero h1 {
  font-size: 30px;
}

#hero h1,
#hero h2 {
  line-height: 1;
}

#hero .btn-get-started {
  margin-top: 20px;
}
</style>
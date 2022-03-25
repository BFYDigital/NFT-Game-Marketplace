<template>
  <Header />
  <main id="main">
    <template v-if="isConnected">
      <HeroSection
        title="Trade ERC721 Zombies!"
        subtitle="want to trade your zombie? click the button below"
        buttonText="CREATE TRADE"
        @buttonClicked="openCreateTradeModal"
      />
      <ZombiesGrid ref="zombieGrid" />
    </template>
    <template v-else>
      <AccountConnection @statusChanged="onConnectionStatusChanged" />
    </template>
  </main>
  <Footer />
</template>

<script lang="ts">
import Header from "./components/Header.vue";
import HeroSection from "./components/HeroSection.vue";
import AccountConnection from "./components/AccountConnection.vue";
import ZombiesGrid from "./components/zombie-ui";
import Footer from "./components/Footer.vue";

export default {
  data: function () {
    return {
      isConnected: false,
    };
  },
  components: {
    Header,
    HeroSection,
    ZombiesGrid,
    AccountConnection,
    Footer,
  },
  methods: {
    onConnectionStatusChanged: function (args) {
      this.isConnected = args.isConnected;
    },
    openCreateTradeModal: function () {
      this.$refs.zombieGrid.createZombieTrade();
    },
  },
};
</script>

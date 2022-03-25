<template>
  <section id="team" class="team section-bg">
    <div class="container">
      <div v-if="zombies.length == 0" class="row">
        <NoZombie />
      </div>
      <div v-else class="row">
        <template v-for="zombie in zombies" :key="zombie.id">
          <ZombieCard
            @tradeClosed="retrieveZombieTrades"
            @tradeCompleted="retrieveZombieTrades"
            :zombie="zombie"
          />
        </template>
      </div>
    </div>
    <LoadingOverlay v-if="state.showOverlay" />
  </section>
  <CreateTrade
    @tradeCreated="retrieveZombieTrades"
    @modalClosed="showCreateTrade = false"
    :show="showCreateTrade"
  />
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { LoadingOverlay } from "../ui";
import { constants } from "ethers";
import { store } from "../../store";
import NoZombie from "./NoZombie.vue";
import ZombieCard from "./ZombieCard.vue";
import CreateTrade from "../CreateTrade.vue";

export default defineComponent({
  data: function () {
    return {
      state: {
        showOverlay: false,
      },
      page: {
        perPage: 100,
        number: 1,
      },
      zombies: [],
      showCreateTrade: false,
    };
  },
  components: {
    NoZombie,
    ZombieCard,
    LoadingOverlay,
    CreateTrade,
  },
  mounted: function () {
    setTimeout(() => this.retrieveZombieTrades(), 1500);
  },
  methods: {
    createZombieTrade: function () {
      this.showCreateTrade = !this.showCreateTrade;
    },
    retrieveZombieTrades: function () {
      const vm = this;

      vm.state.showOverlay = true;
      const accounts = store.accounts;

      store.marketplaceContract?.methods
        .getTrades(vm.page.perPage.toString(), vm.page.number.toString())
        .call({ from: accounts[0] })
        .then(async (response: any) => {
          let trades = response.filter(
            (trade: any) => trade.owner !== constants.AddressZero
          );
          vm.trade = trades;

          let zombies = [];
          for (let i = 0; i < trades.length; i++) {
            const trade = trades[i];
            let zombie = await store.zombieTokenContract?.methods
              .zombies(trade.zombieId)
              .call({ from: accounts[0] });

            zombie.trade = {
              id: parseInt(trade.id),
              owner: trade.owner,
              price: trade.price,
              status: parseInt(trade.status),
              zombieId: parseInt(trade.zombieId),
            };
            zombies.push(zombie);
          }

          vm.zombies = zombies;
          vm.$toast.success("Open trades list updated.");
        })
        .catch((err: Error) => {
          vm.$toast.error("Unable to retrieve zombie trades.");
          console.log(err);
        })
        .finally(() => (vm.state.showOverlay = false));
    },
  },
});
</script>

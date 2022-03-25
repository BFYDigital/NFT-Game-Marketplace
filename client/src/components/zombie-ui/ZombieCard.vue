<template>
  <div class="col-lg-3 col-md-6 d-flex align-items-stretch">
    <div class="member">
      <div class="member-img">
        <div
          v-if="isOwner && zombie.trade.status == 0"
          class="position-relative"
        >
          <div class="dropdown position-absolute top-0 end-0 pt-2 pe-2">
            <button
              class="btn btn-outline-primary dropdown-toggle"
              type="button"
              id="settingsDropdown"
              data-bs-toggle="dropdown"
              aria-expanded="false"
            >
              <i class="bi bi-gear-fill"></i>
            </button>
            <ul class="dropdown-menu" aria-labelledby="settingsDropdown">
              <li>
                <a class="dropdown-item" @click="closeTrade(zombie.id)" href="#"
                  >Close Trade</a
                >
              </li>
            </ul>
          </div>
        </div>
        <ZombieCanvas :dna="zombie.dna" />
      </div>
      <div class="member-info">
        <h4>
          {{ zombie.name }}
          <small class="text-muted ms-1">#{{ zombie.id }}</small>
        </h4>
        <span>
          Trade Status:
          <h6 :class="statusClass">{{ statusTitle }}</h6>
        </span>
        <span>Level: {{ zombie.level }}</span>
        <span
          >Wins: {{ zombie.winCount }} / Losses: {{ zombie.lossCount }}</span
        >
        <div class="pt-3">
          <template v-if="isOwner">
            <button class="btn btn-danger" disabled="disabled">
              YOU OWN THIS ZOMBIE
            </button>
          </template>
          <template v-else>
            <button
              :disabled="!canPurchase"
              class="btn btn-primary"
              @click="purchaseZombie(zombie.trade.id)"
            >
              PURCHASE FOR {{ zombiePrice }} ETH
            </button>
          </template>
        </div>
      </div>
    </div>
  </div>
  <LoadingOverlay v-if="state.isLoading" />
</template>

<script lang="ts">
import { defineComponent } from "vue";
import ZombieCanvas from "./ZombieCanvas.vue";
import { LoadingOverlay } from "../ui";
import { store } from "../../store";
import Web3 from "web3";

export default defineComponent({
  props: {
    zombie: {
      type: Object,
      default: {},
    },
  },
  components: {
    ZombieCanvas,
    LoadingOverlay,
  },
  data: function () {
    return {
      currentAccount: "",
      state: {
        isLoading: false,
      },
    };
  },
  emits: ["tradeClosed", "tradeCompleted"],
  methods: {
    closeTrade: function (tradeId) {
      const vm = this;
      vm.state.isLoading = true;
      const accounts = store.accounts;

      store.marketplaceContract?.methods
        .closeTrade(tradeId)
        .send({ from: accounts[0] })
        .then(() => {
          vm.$toast.success(
            `Trade for ${vm.zombie.name} has successfully been closed.`
          );
          vm.$emit("tradeClosed");
        })
        .catch((err) => {
          vm.$toast.danger(
            `Encountered an error while trying to close trade for ${vm.zombie.name}`
          );
          console.log(err);
        })
        .finally((vm.state.isLoading = false));
    },
    purchaseZombie: function (tradeId) {
      const vm = this;
      vm.state.isLoading = true;
      const accounts = store.accounts;
      let amount = this.zombie?.trade.price;

      store.marketplaceContract?.methods
        .completeTrade(tradeId)
        .send({ from: accounts[0], value: amount })
        .then(() => {
          vm.$toast.success(
            `You have successfully purchased ${vm.zombie.name}`
          );
          vm.$emit("tradeCompleted");
        })
        .catch((err) => {
          vm.$toast.danger(
            `Encountered an error while trying to purchase ${vm.zombie.name}`
          );
          console.log(err);
        })
        .finally((vm.state.isLoading = false));
    },
  },
  mounted: function () {
    this.currentAccount = store.accounts[0];
  },
  computed: {
    isOwner: function () {
      return this.currentAccount === this.zombie?.trade.owner;
    },
    zombiePrice: function () {
      let amount = this.zombie?.trade.price;
      return Web3.utils.fromWei(amount ? amount : "0", "ether");
    },
    canPurchase: function () {
      return this.zombie.trade.status === 0;
    },
    statusTitle: function () {
      let title: string;
      let status = parseInt(this.zombie.trade.status);
      switch (status) {
        case 0:
          title = "OPEN";
          break;
        case 1:
          title = "CLOSED";
          break;
        case 2:
          title = "COMPLETE";
          break;
        default:
          title = "UNKNOWN";
          break;
      }
      return title;
    },
    statusClass: function () {
      let _class: string;
      let status = parseInt(this.zombie.trade.status);
      switch (status) {
        case 0:
          _class = "badge bg-success";
          break;
        case 1:
          _class = "badge bg-danger";
          break;
        case 2:
          _class = "badge bg-info";
          break;
        default:
          _class = "badge bg-secondary";
          break;
      }
      return _class;
    },
  },
});
</script>

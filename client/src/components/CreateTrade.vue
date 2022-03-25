<template>
  <div class="modal fade" :id="_modalID" tabindex="-1">
    <form @submit.prevent="approveAndCreateTrade">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Create Trade</h5>
            <button
              :disabled="state.creating"
              @click="setModalVisibility(false)"
              type="button"
              class="btn-close"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
              <label for="zombieidinput" class="form-label">Zombie ID</label>
              <select
                id="zombieidinput"
                class="form-control"
                v-model="form.zombieId"
              >
                <option disabled value="" selected>Select a zombie</option>
                <option
                  :value="zombie.id"
                  v-for="(zombie, key, index) in userZombies"
                  :key="key"
                >
                  {{ zombie.name }}
                </option>
              </select>
            </div>
            <div class="mb-3">
              <label for="priceinput" class="form-label">Price</label>
              <input
                required
                v-model="form.price"
                type="text"
                class="form-control"
                id="priceinput"
                placeholder="amount in ETH"
              />
            </div>
          </div>
          <div class="modal-footer">
            <button
              :disabled="state.creating"
              type="button"
              class="btn btn-secondary"
              @click="setModalVisibility(false)"
            >
              Close
            </button>
            <button
              :disabled="state.creating"
              type="submit"
              class="btn btn-primary"
            >
              <template v-if="state.creating">
                <Spinner />
                Create
              </template>
              <template v-else>Create</template>
            </button>
          </div>
        </div>
      </div>
    </form>
  </div>
  <LoadingOverlay v-if="state.isLoading" />
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { LoadingOverlay, Spinner } from "./ui";
import * as bootstrap from "bootstrap/dist/js/bootstrap.js";
import { store } from "../store";
import Web3 from "web3";

export default defineComponent({
  props: {
    show: { type: Boolean, default: false },
  },
  emits: ["modalClosed", "tradeCreated"],
  data: function () {
    return {
      form: {
        zombieId: "",
        price: "",
      },
      state: {
        creating: false,
        isApproved: false,
        isApproving: false,
        isLoading: false,
      },
      zombieTrades: [],
      userZombies: [],
      _modal: {},
      _modalID: "createTradeModal",
    };
  },
  components: {
    Spinner,
    LoadingOverlay,
  },
  mounted: function () {
    const modalElem = document.getElementById(this._modalID);
    const modal = bootstrap.Modal.getOrCreateInstance(modalElem, {
      keyboard: false,
    });
    this._modal = modal;
  },
  methods: {
    approveAndCreateTrade: function () {
      const vm = this;

      if (vm.form.zombieId === "" || vm.form.price === "") {
        vm.$toast.warning("Zombie ID and price (ETH) are required");
        return;
      }

      const accounts = store.accounts;
      store.zombieTokenContract?.methods
        .approve(store.marketplaceAddress, vm.form.zombieId)
        .send({ from: accounts[0] })
        .then(() => {
          vm.$toast.info("Approval complete...creating trade.");

          store.marketplaceContract?.methods
            .createTrade(
              vm.form.zombieId,
              Web3.utils.toWei(vm.form.price, "ether")
            )
            .send({ from: accounts[0] })
            .then(() => {
              vm.setModalVisibility(false);
              vm.$toast.success("Trade has successfully been posted!");
              vm.$emit("tradeCreated");
            })
            .catch((err: Error) => {
              vm.$toast.error(
                "Encountered an error while trying to create trade post. Ensure that you own the zombie, and it exists"
              );
              console.log(err);
            })
            .finally(() => {
              console.log("finally @ createTrade method");
              vm.state.creating = false;
            });
        })
        .catch((err: Error) => {
          vm.$toast.error("Encountered an error while requesting approval");
          vm.state.creating = false;
          console.log(err);
        });
    },
    resetFormInputs: function () {
      this.form.zombieId = "";
      this.form.price = "";
    },
    setModalVisibility: function (visible: Boolean) {
      if (visible) {
        this._modal.show();
        this.getUserZombies();
      } else {
        this._modal.hide();
        this.resetFormInputs();
        this.$emit("modalClosed");
      }
    },
    getUserZombies: async function () {
      const vm = this;
      vm.state.isLoading = true;
      const accounts = store.accounts;

      let zombies = [];
      let zombieIds: string[] = await store.zombieTokenContract?.methods
        .getUserOwnedTokenIds(accounts[0])
        .call({ from: accounts[0] });

      if (zombieIds) {
        for (let i = 0; i < zombieIds.length; i++) {
          let parsedId = parseInt(zombieIds[i]);
          let result = await store.zombieTokenContract?.methods
            .zombies(parsedId)
            .call();

          let zombie = {
            id: parsedId,
            cooldownTime: parseInt(result.cooldownTime),
            dna: parseInt(result.dna),
            name: result.name,
            level: parseInt(result.level),
            lossCount: parseInt(result.lossCount),
            winCount: parseInt(result.winCount),
          };
          zombies.push(zombie);
        }
      } else {
        vm.$toast.warning("You don't have any zombies to trade");
      }

      vm.userZombies = zombies;
      vm.state.isLoading = false;
    },
  },
  watch: {
    show: function (val) {
      this.setModalVisibility(val);
    },
  },
});
</script>
<template>
  <section id="pricing" class="pricing">
    <div class="container">
      <div class="row">
        <div class="col-md-6 offset-md-3 mt-4 mt-md-0">
          <div class="box featured">
            <h3>Connect Wallet</h3>
            <p class="text-white">{{ message }}</p>
            <div class="btn-wrap">
              <a
                @click.prevent="connect"
                :disabled="isConnecting || !canConnect"
                href="#"
                class="btn-buy"
              >
                <template v-if="isConnecting">
                  <Spinner />
                  Connecting
                </template>
                <template v-else> Connect </template>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import detectEthereumProvider from "@metamask/detect-provider";
import { AbiItem } from "web3-utils";
import Web3 from "web3";
import FeedingZombie from "../contracts/FeedingZombie.json";
import ZombieMarketplace from "../contracts/ZombieMarketplace.json";
import { store } from "../store";
import { Spinner } from "./ui";

export default defineComponent({
  data: function () {
    return {
      message: "loading...",
      canConnect: false,
      isConnected: false,
      isConnecting: false,
    };
  },
  components: {
    Spinner,
  },
  methods: {
    handleAccountsChanged: function (accounts: Array<string>) {
      const vm = this;
      let newVal: boolean = accounts.length === 0 ? false : true;
      if (vm.isConnected !== newVal) {
        vm.isConnected = newVal;
        vm.$emit("statusChanged", { isConnected: vm.isConnected });
      }
    },
    _setIsConnected: function (val: boolean): void {
      this.isConnecting = val;
    },
    connect: function () {
      const vm = this;
      const ethereum = (window as any).ethereum;
      vm._setIsConnected(true);

      ethereum
        .request({ method: "eth_requestAccounts" })
        .then(vm.handleAccountsChanged)
        .catch((err: any) => {
          console.log(err);
          if (err.code === 4001) {
            vm.message = "Click the connect button to get started. again";
            vm._setIsConnected(false);
          } else if (err.code === -32002) {
            vm.message = "Connection request send. Check Metamask";
          } else {
            vm._setIsConnected(false);
            console.error(err);
          }
        });
    },
  },
  mounted: async function () {
    const vm = this;
    const provider = await detectEthereumProvider();
    if (!provider) {
      vm.message = "Wallet provider not detected. Please install MetaMask.";
      return;
    }
    if (provider !== window.ethereum) {
      vm.message =
        "Please ensure that you do not have multiple wallets installed.";
      return;
    }
    const ethereum = (window as any).ethereum;
    if (ethereum) {
      const web3 = new Web3(ethereum);
      ethereum.on("chainChanged", () => window.location.reload());
      ethereum.on("accountsChanged", () => {
        window.location.reload();
        console.log("accounts changed");
      });

      const accounts = await web3.eth.getAccounts();
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = (ZombieMarketplace.networks as any)[networkId];

      const tokenContract = new web3.eth.Contract(
        FeedingZombie.abi as AbiItem[],
        import.meta.env.VITE_ZOMBIE_TOKEN_ADDESS
      );

      const marketplaceContract = new web3.eth.Contract(
        ZombieMarketplace.abi as AbiItem[],
        deployedNetwork?.address
      );

      store.accounts = accounts;
      store.zombieTokenContract = tokenContract;
      store.marketplaceContract = marketplaceContract;
      store.marketplaceAddress = deployedNetwork?.address;

      vm.message = "Click the connect button to get started.";
      vm.canConnect = true;
      vm.connect();
    }
  },
});
</script>

<style scoped>
section {
  padding: 160px 0;
}
</style>
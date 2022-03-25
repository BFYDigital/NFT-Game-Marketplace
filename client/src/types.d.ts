import {Contract} from 'web3-eth-contract';

declare module '*.vue' {
  import type { DefineComponent } from 'vue';
  const component: DefineComponent<{}, {}, any>;
  export default component;
}

export class ZombieStore {
  accounts: Array<String>;
  zombieTokenContract?: Contract;
  marketplaceContract?: Contract;
  marketplaceAddress?: String
}

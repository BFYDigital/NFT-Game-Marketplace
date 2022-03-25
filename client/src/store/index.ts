import type { ZombieStore } from '@/types';
import { reactive } from 'vue';

export const store: ZombieStore = reactive({
  accounts: [],
  zombieTokenContract: undefined,
  marketplaceContract: undefined,
  marketplaceAddress: undefined
});

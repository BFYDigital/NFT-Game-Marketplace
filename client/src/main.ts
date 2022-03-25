import { createApp } from 'vue';
import App from './App.vue';

import 'bootstrap/dist/css/bootstrap.css';
import './assets/vendor/bootstrap-icons/bootstrap-icons.css';
import 'bootstrap/dist/css/bootstrap-utilities.css';
import './assets/css/style.css';
import 'bootstrap/dist/js/bootstrap.js';

import Toaster from '@meforma/vue-toaster';

createApp(App).use(Toaster).mount('#app');

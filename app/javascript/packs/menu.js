import Vue from 'vue/dist/vue.esm'
import Menu from '../menu.vue'

import { library } from '@fortawesome/fontawesome-svg-core'
import { faBars, faTimes } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

library.add(faBars, faTimes)

Vue.component('font-awesome-icon', FontAwesomeIcon)


var menu = new Vue({
  el: "#side_menu_zone",
  components: { Menu },
  template: '<Menu/>'
})

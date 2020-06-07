import Vue from 'vue/dist/vue.esm'
import SelectLink from '../select_link.vue'


var app = new Vue({
  el: '#select',
  components: { SelectLink },
  template: '<SelectLink/>'
  //render: h => h(App),
  //router: router
})

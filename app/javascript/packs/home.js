import Vue from 'vue/dist/vue.esm'
import Home from '../home.vue'

var app = new Vue({
  el: "#home",
  components: { Home },
  template: "<Home/>"
})

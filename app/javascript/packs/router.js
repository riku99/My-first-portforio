import Vue from 'vue/dist/vue.esm.js'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

const routes = [
  { path: '/', component: User }
]

const router = new VueRouter({
  //mode: 'history',
  routes: routes
})

export default router

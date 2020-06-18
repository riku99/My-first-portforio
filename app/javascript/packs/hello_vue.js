/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

// import Vue from 'vue'
import Vue from 'vue/dist/vue.esm'
import SelectLink from '../select_link.vue'
//import router from './router'

// helloというノードを作成している
//document.body.appendChild(document.createElement('hello'))

var app = new Vue({
  el: "#edit-image-zone",
  data: {
    user_image: "/no-user.png"
  },
  methods: {
    previewImage: function() {
      var u = document.getElementById("u_n_image");
      if(u) {
        var i = document.getElementById("image_form")
        var img = i.files[0];
        const reader = new FileReader();
        reader.onload = () => {
        this.user_image = reader.result;
        };
        reader.readAsDataURL(img);
      } else {
        var i = document.getElementById("image_form");
        var img = i.files[0];
        const reader = new FileReader();
          reader.onload = (event) => {
            var url = reader.result;
            var ele = document.getElementById('u_image');
            ele.setAttribute('width', 120);
            ele.setAttribute('height', 120);
            ele.setAttribute('src', url);
          };
          reader.readAsDataURL(img);
      }
    },
    deleteImage: function() {
      var ele = document.getElementById('u_image');
      var url = "/assets/no-user.png"
      ele.setAttribute('width', 120);
      ele.setAttribute('height', 120);
      ele.setAttribute('src', url);
    }
  }
})

// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>


// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
//
//
//
// If the project is using turbolinks, install 'vue-turbolinks':
//
// yarn add vue-turbolinks
//
// Then uncomment the code block below:
//
// import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// Vue.use(TurbolinksAdapter)
//
// document.addEventListener('turbolinks:load', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: () => {
//       return {
//         message: "Can you say hello?"
//       }
//     },
//     components: { App }
//   })
// })

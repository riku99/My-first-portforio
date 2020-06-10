import Vue from 'vue/dist/vue.esm'

var app = new Vue({
  el: "#flash_info",
  methods: {
    info_timeout: function() {
      var ele = document.getElementById("info");
      ele.style.display = "none";
    }
  },
  computed: {
    timerInfo: function() {
      var ele = document.getElementById("info");
      if(ele.className === "info") {
        setTimeout(this.info_timeout,5000);
        return true
      } else {
        return true
      }
    }
  }
})

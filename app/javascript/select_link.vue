<template>
  <div>
    <div class="feed-select">
      <a v-bind:href="`/users/ ${params_url} /change_to_discovery`" v-bind:class="select_back_dis" class="feed-select-link" v-on:click="select_back_color_dis" data-remote="true">Post</a>
      <a v-bind:href="`/users/ ${params_url} /change_to_comment`" v-bind:class="select_back_com" class="feed-select-link" v-on:click="select_back_color_com" data-remote="true">Comment</a>
      <a v-bind:href="`/users/ ${params_url} /favorite`" v-bind:class="select_back_favo" class="feed-select-link" v-on:click="select_back_color_favo" data-remote="true">Favorite</a>
    </div>
  </div>
</template>

<script>
  export default{
    data: function() {
      return {
        select_back_dis: "select_back",
        select_back_com: "",
        select_back_favo: "",
        params_url: ""
      }
    },
    methods: {
      select_back_color_dis: function() {
        this.select_back_dis = "select_back"
        this.select_back_com = ""
        this.select_back_favo = ""
      },
      select_back_color_com: function() {
        this.select_back_com = "select_back"
        this.select_back_dis = ""
        this.select_back_favo = ""
      },
      select_back_color_favo: function() {
        this.select_back_favo = "select_back"
        this.select_back_dis = ""
        this.select_back_com = ""
      }
    },
    mounted (){
    var $dir = location.href.split("/");
    var $dir2 = $dir[$dir.length -1];
    this.params_url = $dir2
    }
  }
</script>

<style>
  .select_back {
    background-color: rgb(214, 214, 214);
  }

  .feed-select {
    margin: 0 auto;
    margin-top: 10px;
    font-family: Avenir, Helvetica, Arial, sans-serif;
    text-align: center;
    font-weight: bold;
    border-bottom: solid 1px #f1f1f1;
    padding-bottom: 10px;
    display: flex;    /** 子要素を横並びにする **/
    justify-content: space-evenly; /** 子要素の間隔を均等にする **/
  }

  .feed-select-link {
    color: #2c3e50;
    padding: 5px;
    border-radius: 30px;
  }

  .feed-select-link div {
    width: 33%;
  }
</style>

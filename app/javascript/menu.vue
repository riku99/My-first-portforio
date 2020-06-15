<template>
  <div>
    <transition name="menu_appearance">
    <div class="side_menu" v-if="menu_present">
      <button class="close_menu_button" v-on:click="display_menu">
        <font-awesome-icon icon="times"></font-awesome-icon>
      </button>
      <div class="menu-select-link-box">
        <a v-bind:href="'/users/' + current_user" class="menu-select-link">My Page</a>
      </div>
      <div class="menu-select-link-box">
        <a data-method="delete" href="/logout" class="menu-select-link" data-confirm="ログアウトしますか?">Logout</a>
      </div>
    </div>
    </transition>
    <button class="menu_button" v-if="!menu_present" v-on:click="display_menu">
      <font-awesome-icon icon="bars"></font-awesome-icon>
    </button>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    data: function() {
      return {
      menu_present: false,
      current_user: ""
      }
    },
    methods: {
      display_menu: function() {
        if(this.menu_present === false) {
          this.menu_present = true
        } else {
          this.menu_present = false
        }
      }
    },
    mounted() {
      axios.get('/api/users/current_user').then(response => (this.current_user = response.data.id))
    }
  }
</script>

<style>
  .side_menu {
    width: 300px;
    height: 50%;
    background-color: white;
    position: fixed;
    right: 0;
    z-index: 10;
    border-left: 1px solid #bfbfc6;
    border-bottom: 1px solid #bfbfc6;
  }

  .menu_button {
    background: transparent;
    border: none;
    outline: 0;
    font-size: 25px;
    color: rgba(255, 191, 0, 0.8);
    position: absolute;
    top: 50%;
    right: 3%;
    transform: translateY(-50%);
  }

  .close_menu_button {
    background: transparent;
    border: none;
    outline: 0;
    font-size: 20px;
    color: rgba(255, 191, 0, 0.8);
  }

  .menu-select-link-box {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    font-weight: bold;
    text-align: center;
    margin-top: 15px;
  }

  .menu-select-link {
    color: #2c3e50;
    padding: 5px;
    border-radius: 30px;
  }

  .menu_appearance-enter {
    transform: translateX(300px);
  }

  .menu_appearance-enter-active {
    transition: 0.5s;
  }

  .menu_appearance-enter-to {
    opacity: 1;
  }

  .menu_appearance-leave {
    opacity: 1;
  }

  .menu_appearance-leave-active {
    transition: 0.5s;
  }

  .menu_appearance-leave-to {
    transform: translateX(300px);
  }

  @media(max-width: 415px) {
    .side_menu {
      width: 150px;
    }
  }
</style>

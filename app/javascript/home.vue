<template>
  <div>
    <div class="home_message">
    <transition appear name="messe">
      <p>Thank you</p>
      </transition>
    <transition appear name="messe2">
      <p class="seco_message">for visiting</p>
    </transition>
    </div>
    <div class="home_link">
      <div class="home_login">
        <a href="/login" style="color: #0085ff;">ログイン</a>
      </div>
      <div class="home_signup">
        <a href="/users/new" style="color: #0085ff;">アカウントを作成</a>
      </div>
    </div>
  </div>
</template>

<script>

</script>

<style scoped>
  .home_message {
    position: absolute;
    top: 20%;
    left: 15%;
    color: #2c3e50;
    font-family: Avenir, Helvetica, Arial, sans-serif;
    font-weight: bold;
    font-size: 70px;
  }

  .seco_message {
    margin-left: 70px;
  }

  .home_link {
  position: absolute;
  top: 300px;
  left: 55%;
  width: 400px;
  display: flex;
  justify-content: space-evenly;
  font-family: Avenir, Helvetica, Arial, sans-serif;
  }

  .home_login {
  font-size: 20px;
  color: #0085ff;
  border-bottom: solid 2px;
  padding-bottom: 5px;
  }

  .home_signup {
  font-size: 20px;
  color: #0085ff;
  border-bottom: solid 2px;
  padding-bottom: 5px;
  }

  .messe-enter {
    opacity: 0;
  }

  .messe-enter-active {
    transition: 5s;
  }

  .messe-enter-to {
    opacity: 1;
  }

  .messe2-enter {
    opacity: 0;
  }

  .messe2-enter-active {
    transition-delay: 1s;
    transition-duration: 3s;

  }

  .messe2-enter-to {
    opacity: 1;
  }
</style>

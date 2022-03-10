<template>
  <div id="app">
    <img alt="honeypot logo" src="./assets/honeypot.png">
    <Show msg="蜜罐监测捕获的恶意IP及域名展示"/>
  </div>
</template>

<script>
import Show from './components/Show.vue'

export default {
  name: 'App',
  components: {
    Show
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>

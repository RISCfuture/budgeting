<template>
  <nav>
    <ul>
      <navbar-item name="incomes" href="incomes">Incomes</navbar-item>
      <navbar-item name="expenditures" href="expenditures">Expenditures</navbar-item>
      <navbar-item name="totals" href="totals">Totals</navbar-item>
    </ul>
  </nav>
</template>

<script>
  import NavbarItem from './NavbarItem.vue'

  export default {
    components: {NavbarItem}
  }
</script>

<style lang="scss">
  @import "~stylesheets/config";

  nav ul {
    font-family: 'Yanone Kaffeesatz', sans-serif;
    font-size: 96px;

    margin: 0 0 40px;
    padding: 0;
    list-style-type: none;

    display: flex;
    flex-flow: row nowrap;

    li {
      color: $color3;

      &:not(:last-child) {
        margin-right: 10px;
      }

      a, a:active, a:hover, a:visited {
        color: $color5;
      }
    }
  }
</style>

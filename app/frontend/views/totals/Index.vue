<template>
  <div>
    <navbar />

    <dl v-if="totals">
      <dd>{{totals.income | formatSignedMoney}}</dd>
      <dt>Income</dt>

      <dd>
        <dl>
          <dd>{{totals.expenditures | formatSignedMoney}}</dd>
          <dt>Gross</dt>
          <dd>{{totals.taxes | formatSignedMoney}}</dd>
          <dt>Taxes</dt>
          <dd>{{totals.net_expenditures | formatSignedMoney}}</dd>
          <dt>Net</dt>
        </dl>
      </dd>
      <dt>Expenditures</dt>

      <dd class="net">{{totals.total | formatSignedMoney}}</dd>
      <dt>Net</dt>
    </dl>
  </div>
</template>

<script lang="ts">
  import Component, {mixins} from 'vue-class-component'
  import Axios from 'axios'

  import {Totals} from 'types'
  import MoneyFormatting from 'mixins/MoneyFormatting'

  @Component
  export default class Index extends mixins(MoneyFormatting) {
    totals?: Totals = null

    refresh() {
      Axios.get<Totals>('/totals.json')
          .then(response => this.totals = response.data)
          .catch(error => alert(error)) //TODO
    }

    mounted() { this.refresh() }
  }
</script>

<style scoped lang="scss">
  @import "~stylesheets/config";

  .net {
    color: $color2;
    font-size: 96px;
  }
</style>

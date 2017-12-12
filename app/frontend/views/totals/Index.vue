<template>
  <div>
    <navbar />

    <dl>
      <dd>{{income | formatSignedMoney}}</dd>
      <dt>Income</dt>

      <dd>
        <dl>
          <dd>{{expenditures | formatSignedMoney}}</dd>
          <dt>Gross</dt>
          <dd>{{taxes | formatSignedMoney}}</dd>
          <dt>Taxes</dt>
          <dd>{{expendituresAndTaxes | formatSignedMoney}}</dd>
          <dt>Net</dt>
        </dl>
      </dd>
      <dt>Expenditures</dt>

      <dd class="net">{{netTotal | formatSignedMoney}}</dd>
      <dt>Net</dt>
    </dl>
  </div>
</template>

<script>
  import axios from 'axios'
  import {filters} from './../../helpers'

  export default {
    data() {
      return {
        income: null,
        expenditures: null,
        taxes: null,
        expendituresAndTaxes: null,
        netTotal: null
      }
    },
    methods: {
      refresh() {
        axios.get('/totals.json').then(({data}) => {
          this.income = data.income
          this.expenditures = data.gross_expenditures
          this.taxes = data.taxes
          this.expendituresAndTaxes = data.net_expenditures
          this.netTotal = data.total
        }).catch((error) => {
          alert(error) //TODO
        })
      }
    },
    filters,
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

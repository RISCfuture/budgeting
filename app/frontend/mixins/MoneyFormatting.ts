import Vue from 'vue'
import * as numeral from 'numeral'

export default Vue.extend({
  filters: {
    formatMoney(amount: number): string {
      return numeral(amount).format('$0,0[.]00')
    },
    formatSignedMoney(amount: number): string {
      return numeral(amount).format('($0,0)')
    }
  }
})

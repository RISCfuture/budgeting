import numeral from 'numeral'

const filters = {
  formatMoney(amount) {
    return numeral(amount).format('$0,0[.]00')
  },
  formatSignedMoney(amount) {
    return numeral(amount).format('($0,0)')
  }
}

const helpers = {
}

export {filters, helpers}

import {Expenditures, Incomes, Totals} from './views/index'

export default [
  {path: '/', redirect: '/totals'},
  {path: '/expenditures', component: Expenditures, name: 'expenditures'},
  {path: '/incomes', component: Incomes, name: 'incomes'},
  {path: '/totals', component: Totals, name: 'totals'}
]

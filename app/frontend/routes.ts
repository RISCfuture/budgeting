import {RouteConfig} from 'vue-router'
import {Expenditures, Incomes, Totals} from './views/index'

const routes: RouteConfig[] = [
  {path: '/', redirect: '/totals'},
  {path: '/expenditures', component: Expenditures, name: 'expenditures'},
  {path: '/incomes', component: Incomes, name: 'incomes'},
  {path: '/totals', component: Totals, name: 'totals'}
]
export default routes

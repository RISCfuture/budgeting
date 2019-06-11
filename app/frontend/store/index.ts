import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)

export interface RootState {}

import expenditures from './modules/expenditures'
import incomes from './modules/incomes'

import createStore from './create'

export default createStore({expenditures, incomes})

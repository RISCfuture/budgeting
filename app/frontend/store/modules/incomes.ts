import {ActionContext, Module} from 'vuex'
import Axios from 'axios'
import * as _ from 'lodash'

import {Income} from 'types'
import {RootState} from 'store'

export interface IncomesState {
  incomes: Income[]
  incomesLoaded: boolean
  incomesLoading: boolean
  incomesError?: Error
}

const state: IncomesState = {
  incomes: [],
  incomesLoaded: false,
  incomesLoading: false,
  incomesError: null
}

const getters = {
  incomes(state: IncomesState): Income[] {
    return state.incomesLoaded ? state.incomes : []
  },

  incomesByCategory(state: IncomesState, getters: any): {[category: string]: Income[]} {
    return _.groupBy(getters.incomes, record => record.category)
  },

  incomesError(state: IncomesState): Error | null {
    return state.incomesError
  },

  incomesLoading(state: IncomesState): boolean {
    return state.incomesLoading
  }
}

const mutations = {
  RESET_INCOMES(state: IncomesState) {
    state.incomes = []
    state.incomesLoaded = false
    state.incomesLoading = false
    state.incomesError = null
  },

  START_INCOMES(state: IncomesState) {
    state.incomesLoading = true
  },

  APPEND_INCOMES(state: IncomesState, {records}: {records: Income[]}) {
    state.incomes = state.incomes.concat(records)
  },

  FINISH_INCOMES(state: IncomesState) {
    state.incomesLoading = false
    state.incomesLoaded = true
  },

  SET_INCOMES_ERROR(state: IncomesState, {error}: {error: Error}) {
    state.incomes = []
    state.incomesLoaded = true
    state.incomesLoading = false
    state.incomesError = error
  },

  DELETE_INCOME(state: IncomesState, {income}: {income: Income}) {
    state.incomes = _.reject(state.incomes, e => e.id === income.id)
  }
}

const actions = {
  loadIncomes({commit, state}: ActionContext<IncomesState, RootState>, force: boolean = false): Promise<boolean> {
    if (!force && state.incomesLoaded) return Promise.resolve(false)

    return new Promise<boolean>((resolve, reject) => {
      commit('RESET_INCOMES')
      commit('START_INCOMES')
      Axios.get<Income>('/incomes.json').then(response => {
        commit('APPEND_INCOMES', {records: response.data})
        commit('FINISH_INCOMES')
        resolve(true)
      }).catch(error => {
        commit('SET_INCOMES_ERROR', {error})
        reject(error)
      })
    })
  },

  deleteIncome({commit, state}: ActionContext<IncomesState, RootState>, {income}: {income: Income}): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      Axios.delete(`/incomes/${income.id}.json`)
          .then(() => {
            commit('DELETE_INCOME', {income})
            resolve()
          })
          .catch(error => reject(error))
    })
  }
}

const incomes: Module<IncomesState, RootState> = {state, getters, mutations, actions}
export default incomes

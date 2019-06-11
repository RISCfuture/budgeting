import {ActionContext, Module} from 'vuex'
import Axios from 'axios'
import * as _ from 'lodash'

import {Expenditure} from 'types'
import {RootState} from 'store'

export interface ExpendituresState {
  expenditures: Expenditure[]
  expendituresLoaded: boolean
  expendituresLoading: boolean
  expendituresError?: Error
}

const state: ExpendituresState = {
  expenditures: [],
  expendituresLoaded: false,
  expendituresLoading: false,
  expendituresError: null
}

const getters = {
  expenditures(state: ExpendituresState): Expenditure[] {
    return state.expendituresLoaded ? state.expenditures : []
  },

  expendituresByCategory(state: ExpendituresState, getters: any): {[category: string]: Expenditure[]} {
    return _.groupBy(getters.expenditures, record => record.category)
  },

  expendituresError(state: ExpendituresState): Error | null {
    return state.expendituresError
  },

  expendituresLoading(state: ExpendituresState): boolean {
    return state.expendituresLoading
  }
}

const mutations = {
  RESET_EXPENDITURES(state: ExpendituresState) {
    state.expenditures = []
    state.expendituresLoaded = false
    state.expendituresLoading = false
    state.expendituresError = null
  },

  START_EXPENDITURES(state: ExpendituresState) {
    state.expendituresLoading = true
  },

  APPEND_EXPENDITURES(state: ExpendituresState, {records}: {records: Expenditure[]}) {
    state.expenditures = state.expenditures.concat(records)
  },

  FINISH_EXPENDITURES(state: ExpendituresState) {
    state.expendituresLoading = false
    state.expendituresLoaded = true
  },

  SET_EXPENDITURES_ERROR(state: ExpendituresState, {error}: {error: Error}) {
    state.expenditures = []
    state.expendituresLoaded = true
    state.expendituresLoading = false
    state.expendituresError = error
  },

  DELETE_EXPENDITURE(state: ExpendituresState, {expenditure}: {expenditure: Expenditure}) {
    state.expenditures = _.reject(state.expenditures, e => e.id === expenditure.id)
  }
}

const actions = {
  loadExpenditures({commit, state}: ActionContext<ExpendituresState, RootState>, force: boolean = false): Promise<boolean> {
    if (!force && state.expendituresLoaded) return Promise.resolve(false)

    return new Promise<boolean>((resolve, reject) => {
      commit('RESET_EXPENDITURES')
      commit('START_EXPENDITURES')
      Axios.get<Expenditure>('/expenditures.json').then(response => {
        commit('APPEND_EXPENDITURES', {records: response.data})
        commit('FINISH_EXPENDITURES')
        resolve(true)
      }).catch(error => {
        commit('SET_EXPENDITURES_ERROR', {error})
        reject(error)
      })
    })
  },

  deleteExpenditure({commit, state}: ActionContext<ExpendituresState, RootState>, {expenditure}: {expenditure: Expenditure}): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      Axios.delete(`/expenditures/${expenditure.id}.json`)
          .then(() => {
            commit('DELETE_EXPENDITURE', expenditure)
            resolve()
          })
          .catch(error => reject(error))
    })
  }
}

const expenditures: Module<ExpendituresState, RootState> = {state, getters, mutations, actions}
export default expenditures

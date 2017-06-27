import axios from 'axios'
import _ from 'lodash'

export default function buildVuexModule(name, url) {
  return {
    state: {
      [name]: {},
      [`${name}Loaded`]: false,
      [`${name}Loading`]: false,
      [`${name}Error`]: null
    },

    getters: {
      [name]: state => state[`${name}Loaded`] ? state[name] : [],
      [`${name}ByCategory`]: (state, getters) => {
        return _.groupBy(getters[name], (record) => record.category)
      },
      [`${name}Error`]: state => state[`${name}Error`],
      [`${name}Loading`]: state => state[`${name}Loading`]
    },

    mutations: {
      [`RESET_${name.toUpperCase()}`](state) {
        state[name] = []
        state[`${name}Loaded`] = false
        state[`${name}Loading`] = false
        state[`${name}Error`] = null
      },

      [`START_${name.toUpperCase()}`](state) {
        state[`${name}Loading`] = true
      },

      [`APPEND_${name.toUpperCase()}`](state, {records}) {
        state[name] = state[name].concat(records)
      },

      [`FINISH_${name.toUpperCase()}`](state) {
        state[`${name}Loaded`] = true
        state[`${name}Loading`] = false
      },

      [`SET_${name.toUpperCase()}_ERROR`](state, {error}) {
        state[name] = []
        state[`${name}Loaded`] = true
        state[`${name}Loading`] = false
        state[`${name}Error`] = error
      }
    },

    actions: {
      [`load${_.capitalize(name)}`]({commit, state}, force) {
        if (!force && state[`${name}Loaded`]) return Promise.resolve(false)

        return new Promise((resolve, reject) => {
          commit(`RESET_${name.toUpperCase()}`)
          commit(`START_${name.toUpperCase()}`)
          axios.get(url).then(({data: records}) => {
            commit(`APPEND_${name.toUpperCase()}`, {records})
            commit(`FINISH_${name.toUpperCase()}`)
            resolve(true)
          }).catch((error) => {
            commit(`SET_${name.toUpperCase()}_ERROR`, {error})
            reject(error)
          })
        })
      }
    }
  }
}

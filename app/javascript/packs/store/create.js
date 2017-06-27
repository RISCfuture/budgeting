import Vuex from 'vuex'
import createLogger from 'vuex/src/plugins/logger'

const debug = process.env.NODE_ENV !== 'production'

export default function createStore(modules) {
  return new Vuex.Store({modules, strict: debug, plugins: debug ? [createLogger()] : []})
}

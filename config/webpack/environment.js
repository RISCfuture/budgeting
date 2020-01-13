const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
const typescript =  require('./loaders/typescript')
const erb = require('./loaders/erb')

environment.loaders.prepend('erb', erb)
environment.loaders.prepend('typescript', typescript)
environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
module.exports = environment

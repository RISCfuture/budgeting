const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')
const typescript =  require('./loaders/typescript')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.loaders.prepend('typescript', typescript)
environment.loaders.prepend('erb', erb)
module.exports = environment

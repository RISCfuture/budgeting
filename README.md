# Budgeter

A simple app for creating and managing budgets. Rails 5.1, Webpack, Vue.js.

## Deploying

First, set your super-secret login and password in
`app/controllers/application_controller.rb` under the `login_required` method.

Then, deploy on Heroku:

``` sh
heroku create your-app-name
git push heroku master
heroku rake db:migrate
```

## TODO

### Bug fixes

* Make it less easy to accidentally delete things
* Editing category doesn't refresh properly
* Fix footer line
* One form open at a time

### Code improvements

* Figure out how to get `app/assets/images` in the Webpack load path
* Convert form bindings to `v-model`
  * Convert fields to components with `v-model`
* Better error handling
* Reduce code duplication between expenditures/incomes
* Add more Sass variables
* Affix table column spacing
* Comments
* Colorize net total

### New features

* Responsiveness
* Animations
  * Deleting row
  * Expanding form
* Add within category, or autocomplete
* Types: Budget - estimated - subscription/actual

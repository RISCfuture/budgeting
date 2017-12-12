<template>
  <form :method="method.toUpperCase()"
        :action="action"
        @submit.prevent="submit"
        id="new_income">
    <field name="item[category]" :errors="errors">
      <template slot-scope="props">
        <label for="income_category">Category</label>
        <input type="text"
               :name="props.fieldname"
               :value="income.category"
               id="income_category"
               maxlength="126"
               required />
      </template>
    </field>

    <input type="hidden"
           name="income[quantity]"
           :value="income.quantity"
           min="1"
           required />
    <label for="income_name">Item</label>
    <field name="item[name]" :errors="errors">
      <template slot-scope="props">
        <input type="text"
               :name="props.fieldname"
               :value="income.name"
               id="income_name"
               maxlength="126"
               required />
      </template>
    </field>

    <label for="income_amount">Value</label>
    <fieldset>
      <field name="item[unit_amount]" :errors="errors">
        <template slot-scope="props">
          $<input type="number"
                  :name="props.fieldname"
                  :value="income.unit_amount"
                  min="0.01"
                  step="0.01"
                  required
                  id="income_amount" />
        </template>
      </field>
    </fieldset>

    <label for="income_period">Period</label>
    <fieldset>
      every
      <field name="item[period_count]"
             :errors="errors"
             :inline="true">
        <template slot-scope="props">
          <input type="number"
                 :name="props.fieldname"
                 :value="income.period_count"
                 min="1"
                 step="1"
                 required
                 class="small"
                 id="income_period_count"
                 @keyup="updatePeriods"
                 @change="updatePeriods" />
        </template>
      </field>
      <field name="item[period_unit]" :errors="errors" :inline="true">
        <template slot-scope="props">
          <select :name="props.fieldname"
                  id="income_period"
                  required>
            <option value="day" :selected="income.period_unit == 'day'">day
            </option>
            <option value="week" :selected="income.period_unit == 'week'">week
            </option>
            <option value="month" :selected="income.period_unit == 'month'">
              month
            </option>
            <option value="year" :selected="income.period_unit == 'year'">year
            </option>
          </select>
        </template>
      </field>
    </fieldset>

    <field name="item[notes]" :errors="errors">
      <template slot-scope="props">
        <label for="income_notes">Notes</label>
        <textarea :name="props.fieldname"
                  :value="income.notes"
                  id="income_notes" />
      </template>
    </field>

    <div class="form-actions">
      <input type="submit" name="commit" value="Save" />
      <button @click.prevent="cancel">Cancel</button>
    </div>
  </form>
</template>

<script>
  import axios from 'axios'
  import Field from 'components/Field.vue'

  const singulars = ['day', 'week', 'month', 'year']
  const plurals = ['days', 'weeks', 'months', 'years']

  export default {
    props: {
      method: {type: String, required: true},
      action: {type: String, required: true},
      income: {
        default() {
          return {
            quantity: 1,
            period_count: 1,
            period: 'day'
          }
        }
      }
    },
    data() {
      return {
        errors: {}
      }
    },
    components: {Field},
    methods: {
      submit() {
        let data = new FormData(this.$el)
        axios[this.method](this.action, data).then(() => {
          this.$emit('submitted')
        }).catch((error) => {
          if (error.response && error.response.status === 422) {
            this.errors = error.response.data.errors
          }
          else alert(error) //TODO
        })
      },

      cancel() { this.$emit('cancel') },

      reset() {
        this.$el.querySelectorAll('input:not([type=submit]), select, textarea')
            .forEach((element) => {
              if (element.getAttribute('name') === 'item[quantity]' ||
                  element.getAttribute('name') === 'item[period_count]')
                element.value = '1'
              else if (element.getAttribute('name') === 'item[period]')
                element.options[0].selected = true
              else element.value = ''
            })
        this.$emit('reset')
      },

      updatePeriods() {
        let field = this.$el.querySelector('#income_period_count')
        let count = Number.parseInt(field.value)
        let strings = count === 1 ? singulars : plurals
        Array.from(this.$el.querySelector('#income_period').options)
             .forEach((item, index) => {
               item.textContent = strings[index]
             })
      }
    },
    mounted() { this.updatePeriods() }
  }
</script>

<style scoped>
  .small {
    max-width: 50px;
  }
</style>

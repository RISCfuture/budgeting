<template>
  <form :method="method.toUpperCase()"
        :action="action"
        @submit.prevent="submit"
        id="new_expenditure">
    <field name="item[category]" :errors="errors">
      <template slot-scope="props">
        <label for="expenditure_category">Category</label>
        <input type="text"
               :name="props.fieldname"
               v-model="expenditure.category"
               id="expenditure_category"
               maxlength="126"
               required />
      </template>
    </field>

    <label for="expenditure_name">Item</label>
    <fieldset>
      <field name="item[quantity]" :errors="errors" :inline="true">
        <template slot-scope="props">
          <input type="number"
                 :name="props.fieldname"
                 :value="expenditure.quantity"
                 min="1"
                 step="1"
                 class="small"
                 required />
        </template>
      </field>
      &times; &nbsp;
      <field name="item[name]" :errors="errors" :inline="true">
        <template slot-scope="props">
          <input type="text"
                 :name="props.fieldname"
                 :value="expenditure.name"
                 id="expenditure_name"
                 maxlength="126"
                 required />
        </template>
      </field>
    </fieldset>

    <div class="field-row">
      <div>
        <label for="expenditure_amount">Cost</label>
        <fieldset>
          <field name="item[unit_amount]" :errors="errors">
            <template slot-scope="props">
              $<input type="number"
                      :name="props.fieldname"
                      :value="expenditure.unit_amount"
                      min="0.01"
                      step="0.01"
                      required
                      id="expenditure_amount" />
            </template>
          </field>
        </fieldset>
      </div>

      <div>
        <label for="expenditure_period">Period</label>
        <fieldset>
          every
          <field name="item[period_count]"
                 :errors="errors"
                 :inline="true">
            <template slot-scope="props">
              <input type="number"
                     :name="props.fieldname"
                     :value="expenditure.period_count"
                     min="1"
                     step="1"
                     required
                     class="small"
                     id="expenditure_period_count"
                     @keyup="updatePeriods"
                     @change="updatePeriods" />
            </template>
          </field>
          <field name="item[period_unit]" :errors="errors" :inline="true">
            <template slot-scope="props">
              <select :name="props.fieldname"
                      id="expenditure_period"
                      required>
                <option value="day"
                        :selected="expenditure.period_unit == 'day'">
                  day
                </option>
                <option value="week"
                        :selected="expenditure.period_unit == 'week'">
                  week
                </option>
                <option value="month"
                        :selected="expenditure.period_unit == 'month'">month
                </option>
                <option value="year"
                        :selected="expenditure.period_unit == 'year'">
                  year
                </option>
              </select>
            </template>
          </field>
        </fieldset>
      </div>
    </div>

    <label>
      <input type="hidden" name="item[budget]" value="0" />
      <input type="checkbox"
             name="item[budget]"
             value="1"
             :checked="expenditure.budget" /> This is a budget
    </label>
    <label>
      <input type="hidden" name="item[sales_tax]" value="0" />
      <input type="checkbox"
             name="item[sales_tax]"
             value="1"
             :checked="expenditure.sales_tax" />
      Add sales tax
    </label>

    <field name="item[notes]" :errors="errors">
      <template slot-scope="props">
        <label for="expenditure_notes">Notes</label>
        <textarea :name="props.fieldname"
                  :value="expenditure.notes"
                  id="expenditure_notes" />
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
      expenditure: {
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
        let field = this.$el.querySelector('#expenditure_period_count')
        let count = Number.parseInt(field.value)
        let strings = count === 1 ? singulars : plurals
        Array.from(this.$el.querySelector('#expenditure_period').options)
             .forEach((item, index) => {
               item.textContent = strings[index]
             })
      }
    },
    mounted() { this.updatePeriods() }
  }
</script>

<style scoped lang="scss">
  @import "~stylesheets/config";

  .small {
    max-width: 50px;
  }

  #expenditure_name {
    border-bottom: 1px dotted $color4;
  }
</style>

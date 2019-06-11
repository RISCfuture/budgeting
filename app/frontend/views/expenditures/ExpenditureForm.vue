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
               v-model="scratchExpenditure.category"
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
                 v-model="scratchExpenditure.quantity"
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
                 v-model="scratchExpenditure.name"
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
                      v-model="scratchExpenditure.unit_amount"
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
                     v-model="scratchExpenditure.period_count"
                     min="1"
                     step="1"
                     required
                     class="small"
                     ref="expenditurePeriodCount" />
            </template>
          </field>
          <field name="item[period_unit]" :errors="errors" :inline="true">
            <template slot-scope="props">
              <select :name="props.fieldname"
                      id="expenditure_period"
                      ref="expenditurePeriod"
                      required>
                <option v-for="(period, index) in periods" :value="period" :selected="scratchExpenditure.period_unit === period">
                  {{periodNames[index]}}
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
             :checked="scratchExpenditure.budget" /> This is a budget
    </label>
    <label>
      <input type="hidden" name="item[sales_tax]" value="0" />
      <input type="checkbox"
             name="item[sales_tax]"
             value="1"
             :checked="scratchExpenditure.sales_tax" />
      Add sales tax
    </label>

    <field name="item[notes]" :errors="errors">
      <template slot-scope="props">
        <label for="expenditure_notes">Notes</label>
        <textarea :name="props.fieldname"
                  v-model="scratchExpenditure.notes"
                  id="expenditure_notes" />
      </template>
    </field>

    <div class="form-actions">
      <input type="submit" name="commit" value="Save" />
      <button @click.prevent="cancel">Cancel</button>
    </div>
  </form>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Prop} from 'vue-property-decorator'
  import * as _ from 'lodash'
  import Axios from 'axios'

  import {Errors, Expenditure, Period} from 'types'
  import Field from 'components/Field'

  interface ScratchExpenditure {
    category?: string
    quantity: number
    name?: string
    unit_amount?: number
    period_count: number
    period_unit: Period
    budget?: boolean
    sales_tax?: boolean
    notes?: string
  }

  const defaultExpenditure: ScratchExpenditure = {
    quantity: 1,
    period_count: 1,
    period_unit: 'day'
  }

  const singulars = ['day', 'week', 'month', 'year']
  const plurals = ['days', 'weeks', 'months', 'years']

  @Component({
    components: {Field}
  })
  export default class ExpenditureForm extends Vue {
    $el!: HTMLFormElement
    $refs!: {
      expenditurePeriodCount: HTMLInputElement
      expenditurePeriod: HTMLSelectElement
    }

    @Prop({type: Object, required: false}) expenditure?: Expenditure

    scratchExpenditure: ScratchExpenditure = defaultExpenditure
    errors: Errors = {}

    private get pluralizePeriods(): boolean { return Number(this.$refs.expenditurePeriodCount.value) !== 1 }

    get periods(): string[] { return singulars }
    get periodNames(): string[] { return this.pluralizePeriods ? plurals : singulars }

    get method(): string {
      if (_.isNil(this.expenditure)) return 'post'
      else return 'patch'
    }
    get action(): string {
      if (_.isNil(this.expenditure))
        return `/expenditures.json`
      else
        return `/expenditures/${this.expenditure.id}.json`
    }

    submit() {
      let data = new FormData(this.$el)
      Axios[this.method](this.action, data).then(() => {
        this.$emit('submitted')
      }).catch(error => {
        if (error.response && error.response.status === 422) {
          this.errors = error.response.data.errors
        }
        else alert(error) //TODO
      })
    }

    cancel() { this.$emit('cancel') }

    reset() {
      if (_.isNil(this.expenditure))
        this.scratchExpenditure = _.clone(defaultExpenditure)
      else {
        this.scratchExpenditure = _.pick(this.expenditure, [
          'category',
          'quantity',
          'name',
          'unit_amount',
          'period_count',
          'period_unit',
          'budget',
          'sales_tax',
          'notes'
        ]) as ScratchExpenditure
      }
    }

    mounted() { this.reset() }
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

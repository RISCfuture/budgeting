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
               v-model="scratchIncome.category"
               id="income_category"
               maxlength="126"
               required />
      </template>
    </field>

    <input type="hidden"
           name="income[quantity]"
           v-model="scratchIncome.quantity"
           min="1"
           required />
    <label for="income_name">Item</label>
    <field name="item[name]" :errors="errors">
      <template slot-scope="props">
        <input type="text"
               :name="props.fieldname"
               v-model="scratchIncome.name"
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
                  v-model="scratchIncome.unit_amount"
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
                 v-model="scratchIncome.period_count"
                 min="1"
                 step="1"
                 required
                 class="small"
                 ref="incomePeriodCount" />
        </template>
      </field>
      <field name="item[period_unit]" :errors="errors" :inline="true">
        <template slot-scope="props">
          <select :name="props.fieldname"
                  id="income_period"
                  ref="incomePeriod"
                  required>
            <option v-for="(period, index) in periods" :value="period" :selected="scratchIncome.period_unit === period">
              {{periodNames[index]}}
            </option>
          </select>
        </template>
      </field>
    </fieldset>

    <field name="item[notes]" :errors="errors">
      <template slot-scope="props">
        <label for="income_notes">Notes</label>
        <textarea :name="props.fieldname"
                  v-model="scratchIncome.notes"
                  id="income_notes" />
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

  import {Errors, Income, Period} from 'types'
  import Field from 'components/Field'

  interface ScratchIncome {
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

  const defaultIncome: ScratchIncome = {
    quantity: 1,
    period_count: 1,
    period_unit: 'day'
  }

  const singulars = ['day', 'week', 'month', 'year']
  const plurals = ['days', 'weeks', 'months', 'years']

  @Component({
    components: {Field}
  })
  export default class IncomeForm extends Vue {
    $el!: HTMLFormElement
    $refs!: {
      incomePeriodCount: HTMLInputElement
      incomePeriod: HTMLSelectElement
    }

    @Prop({type: Object, required: false}) income?: Income

    scratchIncome: ScratchIncome = defaultIncome
    errors: Errors = {}

    private get pluralizePeriods(): boolean { return Number(this.$refs.incomePeriodCount.value) !== 1 }

    get periods(): string[] { return singulars }
    get periodNames(): string[] { return this.pluralizePeriods ? plurals : singulars }

    get method(): string {
      if (_.isNil(this.income)) return 'post'
      else return 'patch'
    }
    get action(): string {
      if (_.isNil(this.income))
        return `/incomes.json`
      else
        return `/incomes/${this.income.id}.json`
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
      if (_.isNil(this.income))
        this.scratchIncome = _.clone(defaultIncome)
      else {
        this.scratchIncome = _.pick(this.income, [
          'category',
          'quantity',
          'name',
          'unit_amount',
          'period_count',
          'period_unit',
          'budget',
          'sales_tax',
          'notes'
        ]) as ScratchIncome
      }
    }

    mounted() { this.reset() }
  }
</script>

<style scoped>
  .small {
    max-width: 50px;
  }
</style>

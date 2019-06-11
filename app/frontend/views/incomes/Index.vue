<template>
  <div>
    <navbar />

    <table class="ledger">
      <thead>
      <tr>
        <th>Source</th>
        <th>Amount</th>
        <th>Period</th>
        <th>Prorated</th>
        <th></th>
      </tr>
      </thead>

      <template v-for="(incomes, category) in incomesByCategory">
        <category :key="category"
                  :category="category"
                  :incomes="incomes"
                  @updated="reload"></category>
      </template>

      <tfoot>
      <tr v-if="addFormExpanded">
        <td colspan="5" class="add-form">
          <income-form ref="form"
                       @submitted="added"
                       @cancel="toggleAddForm" />
        </td>
      </tr>
      <tr v-else>
        <td colspan="5" class="add-form">
          <a @click="toggleAddForm">
            <img :src="addIconURL" alt="(+)" />
            Add Income
          </a>
        </td>
      </tr>
      </tfoot>
    </table>
  </div>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Action, Getter} from 'vuex-class'

  import {Income} from 'types'
  import Category from './Category'
  import IncomeForm from './IncomeForm'
  import AddIcon from 'images/add.svg'

  @Component({
    components: {Category, IncomeForm}
  })
  export default class Index extends Vue {
    $refs!: {
      form: IncomeForm
    }

    addIconURL = AddIcon
    addFormExpanded = false

    @Getter incomesByCategory: {[category: string]: Income[]}

    @Action loadIncomes: (force: boolean) => Promise<boolean>

    toggleAddForm() {
      if (this.addFormExpanded) this.$refs.form.reset()
      this.addFormExpanded = !this.addFormExpanded
    }

    added() {
      this.reload()
      this.toggleAddForm()
    }

    reload() { this.loadIncomes(true) }

    mounted() { this.loadIncomes(true) }
  }
</script>

<style scoped>
  img {
    width: 16px;
    heifght: 16px;
  }
</style>

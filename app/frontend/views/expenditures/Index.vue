<template>
  <div>
    <navbar />

    <table class="ledger">
      <thead>
      <tr>
        <th>Item</th>
        <th>Cost</th>
        <th>Period</th>
        <th>Prorated</th>
        <th></th>
      </tr>
      </thead>

      <template v-for="(expenditures, category) in expendituresByCategory">
        <category :key="category"
                  :category="category"
                  :expenditures="expenditures"
                  @updated="reload"></category>
      </template>

      <tfoot>
      <tr v-if="addFormExpanded">
        <td colspan="5" class="add-form">
          <expenditure-form ref="form"
                            @submitted="added"
                            @cancel="toggleAddForm" />
        </td>
      </tr>
      <tr v-else>
        <td colspan="6" class="add-form">
          <a @click="toggleAddForm">
            <img :src="addIconURL" alt="(+)" />
            Add Expenditure
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

  import {Expenditure} from 'types'
  import Category from './Category'
  import ExpenditureForm from './ExpenditureForm'
  import AddIcon from 'images/add.svg'

  @Component({
    components: {Category, ExpenditureForm}
  })
  export default class Index extends Vue {
    $refs!: {
      form: ExpenditureForm
    }

    addIconURL = AddIcon
    addFormExpanded = false

    @Getter expendituresByCategory: {[category: string]: Expenditure[]}

    @Action loadExpenditures: (force: boolean) => Promise<boolean>

    toggleAddForm() {
      if (this.addFormExpanded) this.$refs.form.reset()
      this.addFormExpanded = !this.addFormExpanded
    }

    added() {
      this.reload()
      this.toggleAddForm()
    }

    reload() { this.loadExpenditures(true) }

    mounted() { this.loadExpenditures(true) }
  }
</script>

<style scoped>
  img {
    width: 16px;
    heifght: 16px;
  }
</style>

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
          <income-form method="post"
                       action="/incomes.json"
                       ref="form"
                       @submitted="added"
                       @cancel="toggleAddForm" />
        </td>
      </tr>
      <tr v-else>
        <td colspan="5" class="add-form">
          <a @click="toggleAddForm">
            <img :src="AddIcon" alt="(+)" />
            Add Income
          </a>
        </td>
      </tr>
      </tfoot>
    </table>
  </div>
</template>

<script>
  import {mapGetters, mapActions} from 'vuex'
  import {helpers} from '../../helpers'
  import Category from './Category.vue'
  import IncomeForm from './IncomeForm.vue'
  import AddIcon from '../../../../assets/images/add.svg'

  const singulars = ['day', 'week', 'month', 'year']
  const plurals = ['days', 'weeks', 'months', 'years']

  export default {
    data() {
      return {
        AddIcon,
        addFormExpanded: false
      }
    },
    components: {Category, IncomeForm},
    computed: mapGetters(['incomesByCategory']),
    methods: {
      ...mapActions(['loadIncomes']),

      toggleAddForm() {
        if (this.addFormExpanded) this.$refs.form.reset()
        this.addFormExpanded = !this.addFormExpanded
      },

      added() {
        this.reload()
        this.toggleAddForm()
      },

      reload() { this.loadIncomes(true) }
    },
    mounted() { this.loadIncomes() }
  }
</script>

<style scoped>
  img {
    width: 16px;
    heifght: 16px;
  }
</style>

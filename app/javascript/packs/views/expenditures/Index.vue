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
          <expenditure-form method="post"
                            action="/expenditures.json"
                            ref="form"
                            @submitted="added"
                            @cancel="toggleAddForm" />
        </td>
      </tr>
      <tr v-else>
        <td colspan="6" class="add-form">
          <a @click="toggleAddForm">
            <img :src="AddIcon" alt="(+)" />
            Add Expenditure
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
  import ExpenditureForm from './ExpenditureForm.vue'
  import AddIcon from '../../../../assets/images/add.svg'

  export default {
    data() {
      return {
        AddIcon,
        addFormExpanded: false
      }
    },
    components: {Category, ExpenditureForm},
    computed: mapGetters(['expendituresByCategory']),
    methods: {
      ...mapActions(['loadExpenditures']),

      toggleAddForm() {
        if (this.addFormExpanded) this.$refs.form.reset()
        this.addFormExpanded = !this.addFormExpanded
      },

      added() {
        this.reload()
        this.toggleAddForm()
      },

      reload() { this.loadExpenditures(true) }
    },
    mounted() { this.loadExpenditures() }
  }
</script>

<style scoped>
  img {
    width: 16px;
    heifght: 16px;
  }
</style>

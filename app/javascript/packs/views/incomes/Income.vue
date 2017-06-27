<template>
  <tr class="income">
    <td v-if="editFormShown" colspan="5">
      <income-form method="patch"
                        :action="editURL"
                        :income="income"
                        @submitted="finishEdit"
                        @cancel="cancelEdit" />
    </td>
    <th v-if="!editFormShown">{{income.name}}</th>
    <td v-if="!editFormShown">{{income.unit_amount | formatMoney}}</td>
    <td v-if="!editFormShown">{{income.formatted_period}}</td>
    <th v-if="!editFormShown">{{income.prorated_amount | formatMoney}}</th>
    <td v-if="!editFormShown"><a class="action" @click="edit">Edit</a><a class="action" @click="destroy">Delete</a>
    </td>
  </tr>
</template>

<script>
  import axios from 'axios'
  import numeral from 'numeral'
  import {filters} from '../../helpers'
  import IncomeForm from './IncomeForm.vue'

  export default {
    props: ['income'],
    components: {IncomeForm},
    data() {
      return {
        editFormShown: false
      }
    },
    computed: {
      editURL() { return `/incomes/${this.income.id}.json` }
    },
    methods: {
      edit() { this.editFormShown = true },
      finishEdit() {
        this.editFormShown = false
        this.$emit('updated')
      },
      cancelEdit() { this.editFormShown = false },
      destroy() {
        axios.delete(this.editURL).then(() => this.$emit('updated'))
             .catch((error) => {
               alert(error) //TODO
             })
      },
    },
    filters
  }
</script>

<style scoped lang="scss">
  @import "~stylesheets/config";

  a.action {
    text-decoration: underline;
    color: $color1;

    &:not(:last-child) {
      margin-right: 20px;
    }
  }
</style>

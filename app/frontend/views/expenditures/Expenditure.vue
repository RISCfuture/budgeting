<template>
  <tr :class="rowClass">
    <td v-if="editFormShown" colspan="5">
      <expenditure-form method="patch"
                        :action="editURL"
                        :expenditure="expenditure"
                        @submitted="finishEdit"
                        @cancel="cancelEdit" />
    </td>
    <th v-if="!editFormShown">{{expenditure.name}}</th>
    <td v-if="!editFormShown">{{expenditure.unit_amount | formatMoney}} ea.</td>
    <td v-if="!editFormShown">{{expenditure.formatted_period}}</td>
    <th v-if="!editFormShown">{{expenditure.prorated_amount | formatMoney}}</th>
    <td v-if="!editFormShown"><a class="action" @click="edit">Edit</a><a class="action" @click="destroy">Delete</a>
    </td>
  </tr>
</template>

<script>
  import axios from 'axios'
  import numeral from 'numeral'
  import {filters} from '../../helpers'
  import ExpenditureForm from './ExpenditureForm.vue'

  export default {
    props: ['expenditure'],
    components: {ExpenditureForm},
    data() {
      return {
        editFormShown: false
      }
    },
    computed: {
      rowClass() {
        return this.expenditure.budget ? 'budget' : null
      },
      editURL() { return `/expenditures/${this.expenditure.id}.json` }
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

<template>
  <tr :class="rowClass">
    <td v-if="editFormShown" colspan="5">
      <expenditure-form :expenditure="expenditure"
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

<script lang="ts">
  import Component, {mixins} from 'vue-class-component'
  import {Prop} from 'vue-property-decorator'
  import {Action} from 'vuex-class'

  import * as Types from 'types'
  import ExpenditureForm from './ExpenditureForm'
  import MoneyFormatting from 'mixins/MoneyFormatting'

  @Component({
    components: {ExpenditureForm}
  })
  export default class Expenditure extends mixins(MoneyFormatting) {
    @Prop({type: Object, required: true}) expenditure: Types.Expenditure

    editFormShown = false

    get rowClass(): string | null {
      return this.expenditure.budget ? 'budget' : null
    }

    @Action deleteExpenditure: (params: {expenditure: Types.Expenditure}) => Promise<void>

    edit() { this.editFormShown = true }

    finishEdit() {
      this.editFormShown = false
      this.$emit('updated')
    }

    cancelEdit() { this.editFormShown = false }

    destroy() {
      this.deleteExpenditure({expenditure: this.expenditure})
          .then(() => this.$emit('updated'))
          .catch(error => alert(error)) //TODO
    }
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

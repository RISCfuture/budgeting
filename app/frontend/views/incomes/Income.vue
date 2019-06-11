<template>
  <tr class="income">
    <td v-if="editFormShown" colspan="5">
      <income-form :income="income"
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

<script lang="ts">
  import Component, {mixins} from 'vue-class-component'
  import {Prop} from 'vue-property-decorator'
  import {Action} from 'vuex-class'

  import * as Types from 'types'
  import IncomeForm from './IncomeForm'
  import MoneyFormatting from 'mixins/MoneyFormatting'

  @Component({
    components: {IncomeForm}
  })
  export default class Income extends mixins(MoneyFormatting) {
    @Prop({type: Object, required: true}) income: Types.Income

    editFormShown = false

    @Action deleteIncome: (params: {income: Types.Income}) => Promise<void>

    edit() { this.editFormShown = true }

    finishEdit() {
      this.editFormShown = false
      this.$emit('updated')
    }

    cancelEdit() { this.editFormShown = false }

    destroy() {
      this.deleteIncome({income: this.income})
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

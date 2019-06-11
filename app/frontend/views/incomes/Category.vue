<template>
  <tbody>
  <tr class="category" @click="toggle">
    <td colspan="5">
      <span class="disclosure-triangle" v-html="triangle" />{{category}}
    </td>
  </tr>

  <template v-if="expanded" v-for="income in incomes">
    <income :key="income.id"
                 :income="income"
                 @updated="incomeUpdated" />
  </template>

  </tbody>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Prop} from 'vue-property-decorator'

  import Income from './Income'

  @Component({
    components: {Income}
  })
  export default class Category extends Vue {
    @Prop({type: String, required: true}) category: string
    @Prop({type: Array, required: true}) incomes: Income[]

    expanded = true

    get triangle(): string {
      return this.expanded ? '&dtrif;' : '&rtrif;'
    }

    toggle() { this.expanded = !this.expanded }

    incomeUpdated() { this.$emit('updated') }
  }
</script>

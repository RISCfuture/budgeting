<template>
  <tbody>
  <tr class="category" @click="toggle">
    <td colspan="5">
      <span class="disclosure-triangle" v-html="triangle" />{{category}}
    </td>
  </tr>

  <template v-if="expanded" v-for="expenditure in expenditures">
    <expenditure :key="expenditure.id"
                 :expenditure="expenditure"
                 @updated="expenditureUpdated" />
  </template>

  </tbody>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Prop} from 'vue-property-decorator'

  import Expenditure from './Expenditure'

  @Component({
    components: {Expenditure}
  })
  export default class Category extends Vue {
    @Prop({type: String, required: true}) category: string
    @Prop({type: Array, required: true}) expenditures: Expenditure[]

    expanded = true

    get triangle(): string {
      return this.expanded ? '&dtrif;' : '&rtrif;'
    }

    toggle() { this.expanded = !this.expanded }

    expenditureUpdated() { this.$emit('updated') }
  }
</script>

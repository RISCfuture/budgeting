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
                 @updated="updated" />
  </template>

  </tbody>
</template>

<script>
  import Expenditure from './Expenditure.vue'

  export default {
    components: {Expenditure},
    props: ['category', 'expenditures'],
    data() {
      return {
        expanded: true
      }
    },
    computed: {
      triangle() {
        return this.expanded ? '&dtrif;' : '&rtrif;'
      }
    },
    methods: {
      toggle() { this.expanded = !this.expanded },
      updated() { this.$emit('updated') }
    }
  }
</script>

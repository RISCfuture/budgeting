<template>
  <tbody>
  <tr class="category" @click="toggle">
    <td colspan="5">
      <span class="disclosure-triangle" v-html="triangle" />{{category}}
    </td>
  </tr>

  <template v-if="expanded" v-for="income in incomes">
    <income :key="income.id" :income="income" />
  </template>

  </tbody>
</template>

<script>
  import Income from './Income.vue'

  export default {
    components: {Income},
    props: ['category', 'incomes'],
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
      toggle() {
        this.expanded = !this.expanded
      }
    }
  }
</script>

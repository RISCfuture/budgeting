<template>
  <li>
    <template v-if="$route.name === name">
      <slot />
    </template>
    <template v-else>
      <router-link :to="{name: href}">
        <slot />
      </router-link>
    </template>
  </li>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Prop} from 'vue-property-decorator'

  @Component
  export default class NavbarItem extends Vue {
    @Prop({type: String, required: true}) name: string
    @Prop({type: String, required: true}) href: string
  }
</script>

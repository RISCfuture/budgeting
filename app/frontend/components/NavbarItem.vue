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

<script>
  export default {
    props: ['name', 'href']
  }
</script>

<template>
  <div :class="className">
    <slot :fieldname="name" />
    <img :src="AlertIcon"
         :title="fieldErrorString"
         v-if="hasErrors"
         data-arrow="true"
         data-position="right"
         data-animation="scale"
         data-theme="error" />
  </div>
</template>

<script>
  import _ from 'lodash'
  import tippy from 'tippy.js'
  import AlertIcon from '../../../assets/images/alert.svg'

  export default {
    data() {
      return {AlertIcon}
    },
    props: {
      errors: {required: true},
      name: {type: String, required: true},
      inline: {type: Boolean, default: false}
    },
    computed: {
      className() {
        let klass = 'field-error-group'
        if (this.inline) klass += ' inline'
        if (this.fieldErrors) klass += ' error';
        return klass
      },
      fieldErrors() {
        let [match, object, first, rest] = this.name.match(
            /^(\w+)(?:\[(\w+)\]((?:\[\w+\])*))?$/)
        let field = first + rest
        return this.errors[field]
      },
      hasErrors() { return !!this.fieldErrors },
      fieldErrorString() {
        if (!this.hasErrors) return null
        let errors = _.reduce(this.fieldErrors, (result, value) => {
          result.push(value.error)
          return result
        }, [])
        return errors.join(", ")
      },
    },
    updated() {
      tippy(this.$el.querySelector('img'))
    }
  }
</script>

<style scoped>
  div {
    position: relative;
  }

  img {
    position: absolute;
    right: 5px;
    bottom: 10px;
    width: 20px;
    height: 20px;
  }
</style>

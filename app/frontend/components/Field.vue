<template>
  <div :class="className">
    <slot :fieldname="name" />
    <img :src="alertIconURL"
         :title="fieldErrorString"
         v-if="hasErrors"
         data-arrow="true"
         data-position="right"
         data-animation="scale"
         data-theme="error" />
  </div>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Prop} from 'vue-property-decorator'
  import tippy from 'tippy.js'
  import * as _ from 'lodash'

  import {Error, Errors} from 'types'
  import AlertIcon from 'images/alert.svg'

  @Component
  export default class Field extends Vue {
    alertIconURL = AlertIcon

    @Prop({required: true}) errors: Errors
    @Prop({type: String, required: true}) name: string
    @Prop({type: Boolean, default: false}) inline: boolean

    get className(): string {
      let klass = 'field-error-group'
      if (this.inline) klass += ' inline'
      if (this.fieldErrors) klass += ' error';
      return klass
    }

    private get fieldErrors(): Error[] {
      let [match, object, first, rest] = this.name.match(
          /^(\w+)(?:\[(\w+)\]((?:\[\w+\])*))?$/)
      let field = first + rest
      return this.errors[field]
    }

    get hasErrors(): boolean { return !!this.fieldErrors }

    get fieldErrorString(): string {
      if (!this.hasErrors) return null
      let errors = _.reduce(this.fieldErrors, (result, value) => {
        result.push(value.name)
        return result
      }, [])
      return errors.join(", ")
    }

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

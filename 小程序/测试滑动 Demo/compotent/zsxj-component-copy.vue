<template>
	<zsxj-component :list="list" :list_item="list_item" @emitCallBack="emitCallBack"></zsxj-component>
</template>

<script>
	import zsxjComponent from "./zsxj-component.vue"
	export default {
		props:{
			list:Array,
			list_item: Object
		},
		components: {
			zsxjComponent
		},
		methods: {
			emitCallBack(obj) {
				this.$emit("emitCallBack",obj);
			}
		}
	}
</script>

<style>
</style>

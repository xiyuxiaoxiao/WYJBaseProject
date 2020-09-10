<template>
	<zsxj-component :list="list" @emitCallBack="emitCallBack"></zsxj-component>
</template>

<script>
	import zsxjComponent from "./zsxj-component.vue"
	export default {
		props:{
			list:Array
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

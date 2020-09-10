<template>
	<view>
		<block v-for="(item) in list">
			<component-store :info="item" @emitCallBack="emitCallBack">
				<block v-if="item.list">
					<zsxj-component-copy :list="item.list" @emitCallBack="emitCallBack"></zsxj-component-copy>
				</block>
			</component-store>
		</block>
	</view>
</template>

<script>
	import componentStore from "./component-store.vue"
	import zsxjComponentCopy from "./zsxj-component-copy.vue"
	export default {
		props:{
			list:Array
		},
		
		components: {
			componentStore,
			zsxjComponentCopy
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

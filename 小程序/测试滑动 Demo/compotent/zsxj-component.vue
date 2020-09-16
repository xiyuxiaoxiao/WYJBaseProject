<template>
	<view>
		<block v-for="(item) in list">
			<component-store :info="item" :list_item="list_item" @emitCallBack="emitCallBack">
				<block v-if="item.list">
					<zsxj-component-copy :list="item.list" :list_item="list_item" @emitCallBack="emitCallBack"></zsxj-component-copy>
				</block>
			</component-store>
			
			<!-- <block v-if="item.name == 'list'" v-for="(data_item,index) in item.data.list">
				<block v-if="item.list">
					<zsxj-component-copy :list="item.list" @emitCallBack="emitCallBack"></zsxj-component-copy>
				</block>
			</block> -->
			
		</block>
	</view>
</template>

<script>
	import componentStore from "./component-store.vue"
	import zsxjComponentCopy from "./zsxj-component-copy.vue"
	export default {
		props:{
			list:Array,
			list_item: Object
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

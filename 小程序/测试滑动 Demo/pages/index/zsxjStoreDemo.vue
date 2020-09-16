<template>
	<zsxjComponent :list="list" @emitCallBack="emitCallBack"></zsxjComponent>
</template>

<script>
	import zsxjComponent from "../../compotent/zsxj-component.vue"
	export default {
		data() {
			return {
				list:[
					{
						name: "view",
						list: [
							{
								name: "text",
								text:"组件1",
								text_key: "pageData.wyj",
							}
						]
					},
					{
						name: "view",
						list: [
							{
								name: "text",
								text:"组件 2",
							}
						]
					},
					{
						name: "view",
						list: [
							{
								name: "text",
								text:"组件 3",
							}
						]
					},
					{
						name: "view",
						list: [
							{
								name: "text",
								text:"组件 4",
							}
						]
					},
				]
			}
		},
		components: {
			zsxjComponent
		},
		methods: {
			emitCallBack(obj) {
				console.log("组件回调:", obj);
				uni.showToast({
					title: obj.name + ":" + obj.info.text,
				})
			}
		}
	}
</script>

<style>
</style>

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
								click: "1",
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
								name: "view",
								text:"组件 4",
								
								list:[
									{
										name: "view",
										list: [
											{
												name: "text",
												text:"组件 44",
											}
										]
									},
								]
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
				
				this.list[3].list[0].list[0].list[0].text = "修改的数据";
				// this.list.push({
				// 		name: "view",
				// 		list: [
				// 			{
				// 				name: "text",
				// 				text:"组件 5",
				// 			}
				// 		]
				// 	})
			}
		}
	}
</script>

<style>
</style>

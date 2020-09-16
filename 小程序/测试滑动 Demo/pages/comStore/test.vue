<template>
	<zsxjComponent :list="list" @emitCallBack="emitCallBack"></zsxjComponent>
</template>

<script>
	import zsxjComponent from "../../compotent/zsxj-component.vue"
	export default {
		data() {
			return {
				list: []
			}
		},
		
		onLoad() {
			this.list = this.getLayoutData();
			
			let obj = {
					coupon_name: "优惠券 row",
					coupon_list: ["优惠券01","优惠券02","优惠券03"],
				};
				uni.setStoreData("setPageData", obj)
				
		},
		destroyed() {
				uni.setStoreData("setPageData", undefined)
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
				
				if (obj.name == "uni-segmented-control") {
					this.reloadData();
					uni.$emit("update");
				}
			},
			
			reloadData() {
				let obj = {
							coupon_name: "优惠券 row 修改了",
							coupon_list: ["优惠券 1","优惠券 2","优惠券 3","优惠券 4","优惠券 5"],
						};
				uni.setStoreData("setPageData", obj)
			},
			getLayoutData() {
				return [
					{
						name: "view",
						class:"coupon-topBox",
						list:[
							{
								name: "view",
								class:"coupon-segment-box",
								list:[
									{
										name:"uni-segmented-control",
										data:{
											current: 0,
											items: ['未使用', '已使用', '已过期'],
											styleType: 'text',
											activeColor: 'rgba(221,175,117,1)',
										},
									}
								]
							},
							{
								name: "view",
								class: "coupon-list-card",
								list: [
									{
										name: "list",
										data_path: "pageData.coupon_list",
										child_list: [
											{
												name: "text",
												class: "coupon-list-row",
												text:"组件 2",
												data_path: "pageData.coupon_list",
												type: "list_item"
											}
										]
									}
								]
							}
						]
					},
				]
			}
		}
	}
</script>

<style>
</style>

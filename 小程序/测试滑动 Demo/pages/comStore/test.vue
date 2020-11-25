<template>
	<zsxjComponent :list="list" @emitCallBack="emitCallBack"></zsxjComponent>
</template>
<!-- 
	针对列表的 可能需要单独封装一层 list 然后将需要的数据设置进去
	或者根据 node 对象 将数据设置或者子节点设置
 -->
<script>
	import zsxjComponent from "../../compotent/zsxj-component.vue"
	import componentNode from "../../compotent/componentNode.js"
	export default {
		data() {
			return {
				list: [],
				pageData: {
					list_item_id : "0-1-0-0",
					list: []
				},
				coupon_node: {
					name: "view",
					class: "",
					list: [
						{
							name: "text",
							class: "",
							text: "",
						}
					]
					
				}
			}
		},
		
		onLoad() {
			this.list = this.getLayoutData();
			
			componentNode.nodeListInitId(this.list);
			
			this.reloadData(0);
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
				// uni.showToast({
				// 	title: obj.name + ":" + obj.info.text,
				// })
				
				if (obj.name == "uni-segmented-control") {
					this.reloadData(obj.e.currentIndex);
					uni.$emit("update");
					return;
				}
				
				if (obj.info.click == 'show') {
					uni.showToast({
						title: obj.item
					})
					
					// let name = this.list[0].list[2].name;
					// this.list[0].list[2].name = name ? "" : "view";
					return;
				}
				
				if (obj.info.click == "addList") {
					this.reloadData(1, true);
					return;
				}
			},
			
			reloadData(index, next) {
				var source = [{
					name: '未使用',
					count: 3
				},
				{
					name: '已使用',
					count: 10
				},
				{
					name: '已过期',
					count: 20
				}];
				
				let listSuper = componentNode.getNodeByListId(this.list, this.pageData.list_item_id);
				var list = [];
				for (var i = 0; i < 10; i++) {
					
					var flg = i;
					if (next && listSuper.list) {
						flg = i + listSuper.list.length;
					}
					var obj = Object.assign({},listSuper.child);
					obj["text"] = source[index].name + flg;
					list.push(obj);
				}
				
				if (next && listSuper.list) {
					listSuper.list = listSuper.list.concat(list);
				}else {
					listSuper.list = list;
				}
				
				componentNode.nodeListInitId(listSuper.list, listSuper.id);
				
				this.list = JSON.parse(JSON.stringify(this.list));
				console.log("list", JSON.stringify(this.list));
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
										name: "view",
										list: [
											{
												name:"view",
												click:"show",
												child: {
														name: "text",
														class: "coupon-list-row",
														text:"组件 2",
												}
											}
										]
									}
								]
							},
							{
								name: 'view',
								class: "test-view",
								show: 'testView',// show表示当前的view是否显示用哪个字段判断
							},
							{
								name: 'text',
								class: "fixed-button",
								text: "点击",
								click: "addList",
							},
						]
					},
				]
			}
		}
	}
</script>

<style>
</style>

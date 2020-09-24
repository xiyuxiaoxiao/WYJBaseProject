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
			},
			
			reloadData(index) {
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
				
				var listSuper = this.list[0].list[1].list[0].list[0];
				var list = [];
				for (var i = 1; i < source[index].count; i++) {
					var obj = Object.assign({},listSuper.child);
					obj["text"] = source[index].name + i;
					list.push(obj);
				}
				
				// 同时 需要监听 当前数据变化 是否
				
				if (index == 0) {
					this.list[0].list[1].list[0].list[0]['list'] = list;
				}else {
					// this.list[0].list[0].list[0].data.current = 2; // 不修改 也没有影响当前list-current的变化
					this.list[0].list[1].list[0].list[0]['list'][1].text = source[index].name;
				}
				
				this.list = JSON.parse(JSON.stringify(this.list));
				
				console.log("list",this.list);
			},
			
			// updateLayoutData() {
			// 	var s = this.list[0].list[1].list[0].list[0];
			// 	s.list = [];
			// },
			
			// ergodicLayout(list) {
			// 	// 这样不太好处理 主要是递归最后的话 对于list嵌套的list 可能导致数据不到 
			// 	// 需要单独处理 目前先简单处理一下
			// 	for (var item in list) {
			// 		if (item.type == 'list') {
			// 		}
			// 		if (item.list) {
			// 			this.ergodicLayout(item.list);
			// 		}
			// 	}
			// },
			
			
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
						]
					},
				]
			}
		}
	}
</script>

<style>
</style>

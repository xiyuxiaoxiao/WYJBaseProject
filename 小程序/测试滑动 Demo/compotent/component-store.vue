<!-- 
			1. 参数中 字符串 不能使用“” 
			2. @click.stop
			阻止事件冒泡 需要考虑父view 是否点击 不能直接写死 导致点击无效
		需要通过 API 阻止 否则会导致 不需要的地方 父view也不能点击
		
			由于动态设置 是否触发阻止之前的点击事件  需要单独对每个组件设置 不同条件的代码，导致代码会大量增加
		最后决定全局添加，在最后通过数据是否需要 在向外传递是否触发等
-->
<template>
	<view>
		<view v-if="info.name == 'view'" v-bind:class="info.class" @click="click('view')">
			<slot></slot>
		</view>
		<view ref="text" v-if="info.name == 'text'" v-bind:class="info.class" @click="click('text')">
			{{getData()}}
		</view>
		
		<uni-segmented-control v-if="info.name == 'uni-segmented-control'"
		:height="'72rpx'"
		 :current="info.data.current" 
		 :values="info.data.items" 
		 :style-type="info.data.styleType" 
		 :active-color="info.data.activeColor" 
		 :defaultTextColor="'rgb(51,51,51)'"
		 :fontSize="'28rpx'"
		 @clickItem="onClickItem" />
		 
		 <!-- getPropByPath 没有调用  -->
		 <block v-if="info.name == 'list'" v-for="(item,index) in getListData">
			 <zsxj-component-copy :list="info.child_list" :list_item="{'a': listData(index)}" @emitCallBack="emitCallBack"></zsxj-component-copy>
		 </block>
		 
	</view>
</template>

<script>
	import zsxjComponentCopy from "./zsxj-component-copy.vue"
	export default {
		props: {
			info: Object,
			//  该属性为上一级传入的 不允许列表嵌套列表 否则里层的列表 无法获取上一级之的index
			// 如果需要支持列表嵌套里列表，则需要将数据的index 再次传入 可以考虑存储上一层级的index path可以单独设置或者单独存储在数据中
			// 如：list_item: [{index:index,data_path:''},.....]
			list_item: Object,
		},
		data() {
			return {
				getListData: [],
			}
		},
		created() {
			this.reloadLayoutView();
			
			uni.$on("update", (data)=>{
				this.reloadLayoutView();
			})
		},
		watch: {
			'store.state.reload'(val , oldVal) {
				console.log("监听",this.info.name);
				return;
				this.reloadLayoutView();
			}
		},
		methods: {
			click(name) {
				if (!this.info.click) {
					return;
				}
				this.$emit("emitCallBack",{
					name: name,
					info: this.info
				});
			},
			onClickItem(e) {
				this.$emit("emitCallBack",{
					name: this.info.name,
					info: this.info,
					e: e,
				});
			},
			emitCallBack(obj) {
				this.$emit("emitCallBack",obj);
			},
			
			listData(index) {
				return {
					'list_index': index
				}
			},
			
			// 刷新所有需要刷新的View list等 动态的 单独写单独方式即可
			reloadLayoutView() {
				this.reloadListView();
			},
			
			// 刷新列表对象
			reloadListView() {
				if (this.info.name == 'list') {
					console.log("this-path：",this.info.data_path);
					this.getListData = this.getPropByPath(this.info.data_path);
				}
			},
			
			getData() {
				if (this.info.type == "list_item") {
					return this.getPropByPath(this.info.data_path)[this.list_item.a.list_index];
				}
				return this.getPropByPath(this.info.text_key);
			}
		},
		components: {
			zsxjComponentCopy,
		}
	}
</script>

<style>
	.view {
		background-color: #4CD964;
		padding: 20rpx;
		margin: 20rpx;
		width: 100%;
		height: 200rpx;
	}
	
	.text {
		background-color: #F0AD4E;
		padding: 20rpx;
		color: #007AFF;
		font-size: 35rpx;
	}
</style>

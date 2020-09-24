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
			{{info.text}}
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
		 
	</view>
</template>

<script>
	export default {
		props: {
			info: Object,
		},
		methods: {
			click(name) {
				if (!this.info.click) {
					return;
				}
				this.$emit("emitCallBack",{
					name: name,
					info: this.info,
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
		},
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

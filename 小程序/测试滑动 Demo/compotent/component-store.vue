<!-- 
			1. 参数中 字符串 不能使用“” 
			2. @click.stop
			阻止事件冒泡 需要考虑父view 是否点击 不能直接写死 导致点击无效
		需要通过 API 阻止 否则会导致 不需要的地方 父view也不能点击
-->
<template>
	<view>
		<view v-if="info.name == 'view'" class="view" @click="click('view')">
			<slot></slot>
		</view>
		<view v-if="info.name == 'text'" class="text" @click.stop="click('text')">
			{{info.text}}
		</view>
	</view>
</template>

<script>
	export default {
		props: {
			info: Object,
		},
		methods: {
			click(name) {
				this.$emit("emitCallBack",{
					tyle: "textClick",
					name: name,
					info: this.info
				});
			}
		}
	}
</script>

<style>
	.view {
		background-color: #4CD964;
		padding: 20rpx;
		margin: 20rpx;
	}
	
	.text {
		background-color: #F0AD4E;
		padding: 20rpx;
		color: #007AFF;
		font-size: 35rpx;
	}
</style>

<template>
	
	<view>
		<block v-for="(item, index) in list">
			<view class="item" @click="itemClick(index)">{{item.title}}</view>
		</block>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				list:[
					{title: "仿iOS section header效果",path: "/pages/index/index"},
					{title: "隐藏导航栏",path: "/pages/index/navigateHidden"},
					{title: "底部卡片模式",path: "/pages/index/bottomCard"},
				]
			}
		},
		onLoad() {
	
		},
	
		onReady() {
			uni.hideTabBar({
				
			})
		},
	
		methods: {
			itemClick(i) {
				uni.navigateTo({
					url: this.list[i].path
				})
			}
		}
	}
</script>

<style>
	.item {
		margin: 20rpx;
		background-color: #C8C7CC;
		padding: 20rpx 40rpx;
		color: #000000;
	}
</style>

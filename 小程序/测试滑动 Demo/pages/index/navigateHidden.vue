<template>
	<view>
		<view class="navigate-box" :style="{'padding-top': statusBarHeight + 'px',opacity: naviBarOpacity}">
			<view class="navigate-content f-a-c">
				<view class="left f-c" @click="back">back</view>
				<view class="title f-c">自定义导航栏</view>
				<view class="left f-c"></view>
			</view>
		</view>
		
		<view class="page-content"></view>
		<view class="page-content"></view>
		<view class="page-content"></view>
		<view class="page-content"></view>
		<view class="page-content"></view>
		
		<view></view>
	</view>
	
</template>

<script>
	export default {
		data() {
			return {
				statusBarHeight: 0, 	//状态栏高度
				naviBarHeight: 44,		// 导航栏高度
				naviBarOpacity: 0,
			}
		},
		onLoad() {
			const res = uni.getSystemInfoSync();
			console.log("设别:", res);
			this.statusBarHeight = res.statusBarHeight;
		},
	
		onReady() {
			
		},
		
		onPageScroll(e) {
			// min max 表示 透明的开始和结束范围 根据比例显示
			var min = 40;
			var max = 120;
			var opacity = 0;
			if (e.scrollTop > max) {
				opacity = 1;
			}else if (e.scrollTop > min) {
				opacity = (e.scrollTop - min) / (max - min);
			}
			
			this.naviBarOpacity = opacity;
		},
	
		methods: {
			back() {
				uni.navigateBack({});
			}
		}
	}
</script>

<style>
	.navigate-box {
		position: fixed;
		top: 0;
		width: 100%;
		overflow: hidden;
		background-color: #FFFFFF;
	}
	
	.navigate-content {
		text-align: center;
		height: 44px;
	}
	
	.f-a-c {
		display: flex;
		align-items: center;
	}
	
	.f-c {
		display: flex;
		align-items: center;
		justify-content: center;
	}
	
	.navigate-content .left {
		height: 100%;
		width: 120rpx;
	}
	.navigate-content .title {
		flex: 1;
		height: 100%;
	}
	
	.page-content {
		margin-bottom: 50rpx;
		height: 400rpx;
		background-color: #F0AD4E;
	}
</style>

<template>
	<view class="content-box" :class="{'rotateY-back-front': show}">
		<view class="content" :style="'background-image: url(' + url + ');'">
		</view>
	</view>
</template>

<script>
	export default {
		props: {
			url: String,
			onShow: Boolean,
		},
		data: function(){
			return {
				show: false
			}
		},
		methods: {
		},
		watch: {
			onShow(newValue, oldValue) {
				this.show = newValue;
			},
		}
	}
</script>

<style>
	@import "./animations.css";

	.content-box {
		padding: 30rpx;
		width: 100%;
		height: 100%;
		box-sizing: border-box;
	}
	.content {
		width: 100%;
		height: 100%;
		box-sizing: border-box;
		background-size: 100% 100%;
		background-image: url("http://lc-ttWBGSJO.cn-n1.lcfile.com/m0Wap3d9HQ5P6BahGj363TcGpSyGrVO8/700.gif");
	}
	
</style>

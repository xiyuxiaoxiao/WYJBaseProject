<template>
	<view class="contentSize">
		<swiper class="contentSize perspective" vertical="true" @change="swiperChange">
			<swiper-item v-for="(item, index) in list">
				<item-temple class="contentSize  swiper-item" :url="item" :onShow="currentIndex == index">
				</item-temple>
			</swiper-item>
		</swiper>
	</view>
</template>

<script>
	import itemTemple from "../temple/temple.vue";
	
	export default {
		data: function() {
			return {
				currentIndex: -1,
				list: [
					"http://lc-ttWBGSJO.cn-n1.lcfile.com/412117a3b8d0cab18d3f.png/logo.png",
					"http://lc-ttwbgsjo.cn-n1.lcfile.com/a2a26527617f0b93c0ac.png/mascot.png",
					"http://lc-ttWBGSJO.cn-n1.lcfile.com/8c721bee756b80aa12c9.jpeg/basicprofile.jpeg",
					"http://lc-ttWBGSJO.cn-n1.lcfile.com/55069d0338d46cfe59a3.png/%E8%83%8C%E6%99%AF%E5%9B%BE-3-1%E5%A4%87%E4%BB%BD%402x.png",
					"http://lc-ttWBGSJO.cn-n1.lcfile.com/m0Wap3d9HQ5P6BahGj363TcGpSyGrVO8/700.gif",
					"http://lc-ttWBGSJO.cn-n1.lcfile.com/ce2a9ea0b9ee13a4e369.gif/t01764e391c3822694d.gif",
				]
			}
		},
		created() {
			setTimeout(() => {
				this.currentIndex = 0;
			}, 300);
		},
		methods: {
			swiperChange(e) {
				console.log("打印",e.target.current);
				this.currentIndex = e.target.current;
			},
		},
		components: {
			itemTemple,
		}
	}
</script>

<style>
	page {
		height: 100%;
		width: 100%;
	}
	.contentSize {
		height: 100%;
		width: 100%;
		box-sizing: border-box;
	}
	.swiper-item {
		background-color: #3F536E;
		color: #FF0000;
	}
</style>

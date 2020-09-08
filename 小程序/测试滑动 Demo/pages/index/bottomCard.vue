<!-- disableScroll 在pages.json中 可以禁止上下滑动 -->
<template>
	<view class="content">
		<view class="background">手指滑动底部卡片 可以移动</view>
		<view class="card" :animation="animationData" @touchstart="touchstart" @touchend="touchend"></view>
	</view>
</template>

<script>
	export default {
		data () {
			return {
				// animation:
				animationData: {},
				
				translate: false, //表示是否 是原始的 否则是原始的 偏移0
				translate_offset: 150,
				touch: {
					offset_top: 0,
					start_y: 0,
					end_y: 0,
				}
			}
		},
		
		methods: {
			cardAnimation(translate) {
				
				if (this.translate == translate) {
					return;
				}
				this.translate = translate;
				
				var animation = uni.createAnimation({
				  transformOrigin: "50% 50%",
				  duration: 400,
				  timingFunction: "ease",
				});
				
				this.animation = animation;
				
				var offset_y = this.translate ? this.translate_offset : 0;
				animation.translateY(offset_y).step();
				
				this.animationData = animation.export();
			},
			touchstart(e) {
				this.touch.start_y = e.touches[0].pageY;
				this.touch.offset_top = e.target.offsetTop;
			},
			touchend(e) {
				this.touch.end_y = e.changedTouches[0].pageY;
				
				// 判断 最后的点 是否在 当前view上
				let offset_top = (this.translate ? this.touch.offset_top : this.touch.offset_top + this.translate_offset);
				if (this.touch.end_y > offset_top) {
					let offset = this.touch.end_y - this.touch.start_y;
					if (offset > 10) {// 向下
						this.cardAnimation(true)
					}
					else if (offset < -10) {// 向上
						this.cardAnimation(false);
					}
				}
				this.clearTouch();
			},
			clearTouch() {
				this.touch = {
					offset_top: 0,
					start_y: 0,
					end_y: 0,
				}
			}
		}
	}
</script>

<style>
	page {
		height: 100%;
	}
	.content {
		height: 100%;
		width: 100%;
	}
	.background {
		background-color: #DDCCFF;
		height: 100%;
		width: 100%;
		
		padding-top: 200rpx;
	}
	
	.card {
		position: fixed;
		bottom: 0;
		width: 100%;
		height: 70%;
		background-color: #DD524D;
	}
</style>

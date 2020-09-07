<template>
	<view class="content">
		<view class="segment-box center">
			<block v-for="(item, index) in list">
				<view class="tab-item center" :class="{selected: tab_index == index}" @click="tapClick(index)">{{index}}</view>
			</block>
		</view>

		<block v-for="(item, index) in list">
			<view :class="{'section-fixed': tab_index == index}" class="section-header" v-bind:style="{top:fixed_top+'px'}" :id="'section-header' + index">header
				{{index}}</view>
			<!-- placeholder 占位-->
			<view v-if="tab_index == index" class="section-header placeholder">sectionHeader2</view>

			<!-- content -->
			<view class="page-item" :id="'section-content' + index">
				<view class="line"></view>
			</view>
		</block>

		<view :style="{height: fill_height + 'px'}"></view>

	</view>
</template>

<script>
	/*		
	pageScrollTo  跳转指定位置
	selector: "#section-header" + n,
	在模拟器上 selector不稳定  scrollTop 比较兼容
		主要是fixed的原因 没有fixed的话 则正常
		对于在最后部分 如果指定的top或者 selector 作为顶点,无法超出页面内容
		会导致出问题, 需要手动刷新才能恢复,所以目前办法是 
		1.通过动画部分 时间控制,让 手动点击后 允许触发onPageScroll 则可以正常.
		(会出现 当已经处于最后一个 但是不足 再次点击最后一个还是会有问题)
		2.记录一下 对应的后面所有内容都不足一页的时候,需要跳的 top值
		3. 在最后添加一个空的高度 以弥补 不足的一页.
	*/
	export default {
		data() {
			return {
				tab_tap_scrolling: false, //在点击切换的时候 不允许page重复走 默认动画300
				tab_index: 0, // 当前处于哪一个范围
				fixed_top: 0, // 距离顶部的距离
				fill_height: 0, // 后面需要填充的高度 为了解决上面注释的问题
				page_item: {
					header_bottom: 0,// 每个模块的头部下面使用的间距 使用px单位
					content_bottom: 20,// 每个模块的下面的间距 使用px单位
				}, 
				list: [{
					// header_rect: {}, // 头部的 rect
					// content_rect: {} // 内容部分的rect 计量不要使用bottom来 在内部使用
				}, {}, {}]
			}
		},
		onLoad() {

		},

		onReady() {
			let length = this.list.length;
			for (var i = 0; i < length; i++) {
				this.selcetHeader(i);
			}
		},

		onPageScroll(e) {
			if (this.tab_tap_scrolling) {
				return;
			}

			let tab_item = this.list[this.tab_index];
			let offset = 0 - (e.scrollTop + tab_item.header_rect.height - tab_item.content_rect.bottom);
			this.fixed_top = offset < 0 ? offset : 0;

			console.log("哈:", e.scrollTop);

			// 找出当前处于的section
			var selectIndex = 0;
			let length = this.list.length;
			for (var i = 0; i < length; i++) {
				let item = this.list[i];
				if (e.scrollTop >= item.header_rect.top) {
					selectIndex = i;
				}
			}
			if (this.tab_index != selectIndex) {
				this.tab_index = selectIndex;
				this.fixed_top = 0;
			}
		},
		methods: {
			tapClick(n) {
				if (this.tab_index == n) {
					return;
				}

				this.tab_tap_scrolling = true;
				this.cachePageScrollTop = -1;
				setTimeout(() => {
					this.tab_tap_scrolling = false;
				}, 400);

				uni.pageScrollTo({
					scrollTop: this.list[n].header_rect.top,
				})
				this.tab_index = n;
				this.fixed_top = 0;
			},

			selcetHeader: function(i) {
				const query = uni.createSelectorQuery().in(this);

				let that = this;
				query.select('#section-header' + i).boundingClientRect(data => {
					console.log("header位置" + JSON.stringify(data));
					that.list[i].header_rect = data;
					that.setFillHeight();
				}).exec();


				query.select('#section-content' + i).boundingClientRect(data => {
					console.log("content位置" + JSON.stringify(data));
					that.list[i].content_rect = data;

					that.setFillHeight();
				}).exec();
			},

			
			setFillHeight() {

				let lastItem = this.list[this.list.length - 1];
				if (lastItem.header_rect == undefined || lastItem.content_rect == undefined) {
					return;
				}

				// 此处需要注意 header和content的bottom 也需要减去
				let height = uni.getSystemInfoSync().windowHeight - lastItem.header_rect.height - lastItem.content_rect.height - this.page_item.header_bottom - this.page_item.content_bottom;
				this.fill_height = height > 0 ? height : 0;
				console.log("设备信息:", uni.getSystemInfoSync());
			}
		}
	}
</script>

<style>
	.content {
		padding-left: 110rpx;
		padding-bottom: 10rpx;
		height: 100%;
	}

	.segment-box {
		position: fixed;
		top: 10rpx;
		bottom: 10rpx;
		left: 10rpx;
		width: 100rpx;
		overflow: hidden;
		background-color: #1D69A9;
		margin: 0 auto;
	}

	.center {
		display: flex;
		flex-direction: column;
		justify-content: center;
	}

	.tab-item {
		width: 100%;
		height: 100rpx;
		background-color: #F0AD4E;
		margin-bottom: 30rpx;

		text-align: center;
		font-size: 40rpx;
		font-weight: 600;
	}

	.selected {
		color: #FFFFFF;
		background-color: #DD524D;
	}

	.page-item {
		background-color: #C0C0C0;
		margin-bottom: 20px;
		height: 800rpx;
	}

	.section-header {
		background: #545378;
		padding: 20rpx 0;
		color: #FFFFFF;
	}

	.placeholder {
		visibility: hidden;
	}

	.section-fixed {
		position: fixed;
		top: 0;
		width: 100%;
	}

	.line {
		background-color: #FF0000;
		height: 10rpx;
		width: 100%;
	}
</style>

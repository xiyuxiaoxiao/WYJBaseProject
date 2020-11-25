<script>
	export default {
		onLaunch: function() {
			console.log('App Launch')
		},
		onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		}
	}
</script>

<style>
	/*每个页面公共css */
	.coupon-topBox {
		width: 100%;
		background: rgba(200, 200, 200,1);
		margin: 0;
	}
	
	.coupon-segment-box {
		width: 100%;
		position: fixed; 
		top:0;
		z-index: 1;
		background: #FFFFFF;
		height: 80rpx;
	}
	.coupon-list-card{
		margin: 80rpx 21rpx 14rpx 19rpx;
	}
	
	.coupon-list-row {
		background: #F0AD4E;
		padding: 30rpx 20rpx;
		margin: 30rpx 20rpx;
	}
	
	.test-view {
		background: #F00AFE;
		padding: 30rpx 20rpx;
		margin: 30rpx 20rpx;
		margin-top: 100rpx;
		height: 40rpx;
	}
	
	.fixed-button {
		width: 100rpx;
		position: fixed; 
		top:100rpx;
		right: 20rpx;
		z-index: 1;
		background: #F000F0;
		height: 80rpx;
	}
	
</style>

<template>
	<view @click="toSub">
		吉林省积分
	</view>
</template>

<script>
	export default {
		methods: {
			toSub(){
				uni.navigateTo({
					url: "/pagesWedding/index/index"
				});
			}
		}
	}
</script>
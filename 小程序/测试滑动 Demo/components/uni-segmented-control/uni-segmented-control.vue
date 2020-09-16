<template>
	<view :class="[styleType === 'text'?'segmented-control--text' : 'segmented-control--button' ]" :style="{ borderColor: styleType === 'text' ? '' : activeColor , height:height}" class="segmented-control">
		<view :id="'item' + index" v-for="(item, index) in values" :class="[ styleType === 'text'?'segmented-control__item--text': 'segmented-control__item--button' , index === currentIndex&&styleType === 'button'?'segmented-control__item--button--active': '' , index === 0&&styleType === 'button'?'segmented-control__item--button--first': '',index === values.length - 1&&styleType === 'button'?'segmented-control__item--button--last': '' ]" :key="index" :style="{
        backgroundColor: index === currentIndex && styleType === 'button' ? activeColor : '',borderColor: index === currentIndex&&styleType === 'text'||styleType === 'button'?'transparent':'transparent'
      }" class="segmented-control__item" @click="_onClick(index)">
			<text :style="{color:
          index === currentIndex
            ? styleType === 'text'
              ? activeColor
              : '#fff'
            : styleType === 'text'
              ? defaultTextColor
              : activeColor,fontSize:fontSize,fontWeight:fontWeight,lineHeight:fontSize}" class="segmented-control__text">{{ item }}</text>
		</view>
		<view id="bottom-view" class="bottom-view" 
			:style="'height:' + bottomViewHeight + 'rpx;'
			+ 'width:' + bottomViewWidth + 'rpx;'
			+ 'background:' + activeColor + ';'
			" :animation="bottomViewAni"></view>
	</view>
</template>

<script>
	export default {
		name: 'UniSegmentedControl',
		props: {
			current: {
				type: Number,
				default: 0
			},
			values: {
				type: Array,
				default () {
					return []
				}
			},
			activeColor: {
				type: String,
				default: '#007aff'
			},
			styleType: {
				type: String,
				default: 'button'
			},
			height: {
				type: String,
				default: '72rpx'
			},
			defaultTextColor: {
				type: String,
				default: '#000'
			},
			fontSize:{
				type: String,
				default: '16px'
			},
			fontWeight:{
				type: String,
				default: '400'
			},
			bottomViewWidth: {
				type: Number,
				default: 80
			},
			bottomViewHeight: {
				type: Number,
				default: 4
			}
		},
		data() {
			return {
				currentIndex: 0,
				bottomViewAni:'',
				bottomVW:'',
			}
		},
		watch: {
			current(val) {
				if (val !== this.currentIndex) {
					this.currentIndex = val
					const query = uni.createSelectorQuery().in(this);
					query.select('#item' + this.currentIndex).boundingClientRect(data => {
						this.animation.left(data.left + (data.width-this.bottomVW)/2 ).step()
						this.bottomViewAni = this.animation.export()
					}).exec();
				}
			}
		},
		created() {
			this.currentIndex = this.current
			if(this.current >= this.values.length){
				this.currentIndex = 0
			}
			this.animation = uni.createAnimation({duration: 200})
			const query = uni.createSelectorQuery().in(this);
			query.select('#bottom-view').boundingClientRect(data => {
				if(data){
					this.bottomVW = data.width;
				}
			}).exec();
			query.select('#item' + this.currentIndex).boundingClientRect(data => {
				if(data){
					this.bottomViewAni = uni.createAnimation({duration: 0}).left(data.left + (data.width-this.bottomVW)/2 ).step().export()
				}
			}).exec();
		},
		methods: {
			_onClick(index) {
				if (this.currentIndex !== index) {
					this.currentIndex = index
					this.$emit('clickItem', {
						currentIndex: index
					})
				}
				const query = uni.createSelectorQuery().in(this);
				query.select('#item' + this.currentIndex).boundingClientRect(data => {
					if(data){
						this.animation.left(data.left + (data.width-this.bottomVW)/2 ).step()
						this.bottomViewAni = this.animation.export()
					}
				}).exec();
			}
		}
	}
</script>

<style scoped>
	.segmented-control {
		/* #ifndef APP-NVUE */
		display: flex;
		box-sizing: border-box;
		/* #endif */
		flex-direction: row;
		overflow: hidden;
		position:relative;
	}

	.segmented-control__item {
		/* #ifndef APP-NVUE */
		display: inline-flex;
		box-sizing: border-box;
		/* #endif */
		position: relative;
		flex: 1;
		justify-content: center;
		align-items: center;
	}

	.segmented-control__item--button {
		border-style: solid;
		border-top-width: 1px;
		border-bottom-width: 1px;
		border-right-width: 1px;
		border-left-width: 0;
	}

	.segmented-control__item--button--first {
		border-left-width: 1px;
		border-top-left-radius: 5px;
		border-bottom-left-radius: 5px;
	}

	.segmented-control__item--button--last {
		border-top-right-radius: 5px;
		border-bottom-right-radius: 5px;
	}

	.segmented-control__item--text {
		border-bottom-style: solid;
		border-bottom-width: 3px;
	}

	.segmented-control__text {
		text-align: center;
	}
	.bottom-view{
		position:absolute;
		bottom: 0;
	}
</style>
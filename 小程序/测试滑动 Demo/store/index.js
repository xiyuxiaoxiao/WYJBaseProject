import Vue from 'vue'  // 引入vue
import Vuex from 'vuex'  // 引入vuex
 
// 使用vuex
Vue.use(Vuex)
 
// 创建vuex实例
const store = new Vuex.Store({
    state: {
		reload: false,
		pageData: {
			wyj: "wangyangjun",
			coupon_name: "优惠券 row",
			coupon_list: [
				1,2,3
			],
		},
	},
	mutations: {
		setPageData(state,pageData) {
			console.log("修改数据了");
			state.pageData = pageData;
		},
		setReload(state, value) {
			state.reload = value;
		}
	}
})
 
export default store
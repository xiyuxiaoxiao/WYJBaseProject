import Vue from 'vue'
import App from './App'

import store from './store' 

Vue.config.productionTip = false
// Vue.prototype.store = store;
Vue.prototype.getPropByPath = getPropByPath;

App.mpType = 'app'

uni.store = store;
uni.setStoreData = function(method, value) {
	uni.store.commit(method, value);
}

const app = new Vue({
    ...App,
	store,
})
app.$mount()

// 获取value的方法 obj为要获取的对象，path是路径 用.链接
function getPropByPath(path, obj) {
	console.log("路径：",path);
	let tempObj = obj;
	if (!obj) {
		
		tempObj = uni.store.state; //默认获取
	}
	  if (!path) {
		  return undefined;
	  }
	  
      path = path.replace(/\[(\w+)\]/g, '.$1')
      path = path.replace(/^\./, '')
      let keyArr = path.split('.')
	  let len = keyArr.length;
      for (var i =0; i < len; i++) {
        let key = keyArr[i]
        if (key in tempObj) {
          tempObj = tempObj[key]
        } else {
          return undefined;
        }
      }
      return tempObj;
    }
 
//  调用示例 
// var obj = {name:'objname', items:[{value: 0},{value: 1}]}, path = 'items.0.value'; console.log( getPropByPath(obj, path).v );



import router from '@ohos.router'
import { loge, logi } from '../utils/LogUtil';

export class Router {
  static push(url: string, params?: Object, routerMode: router.RouterMode = router.RouterMode.Standard) {
    router.pushUrl({ url: url, params: params }, routerMode, (err) => {
      if (err) {
        loge(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      logi('pushUrl success' + url);
    })
  }

  static replace(url: string, params?: Object, routerMode: router.RouterMode = router.RouterMode.Standard) {
    router.replaceUrl({ url: url, params: params }, routerMode, (err) => {
      if (err) {
        loge(`replaceUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      logi('replaceUrl success' + url);
    })
  }

  static back(url: string, params?: Object) {
    router.back({ url: url, params: params })
  }

  static clear() {
    router.clear()
  }
}
import { AxiosError, AxiosRequestHeaders } from '@ohos/axios';
import { logd, loge, logjson } from '../utils/LogUtil';
import { hideLoadingDialog, showLoadingDialog } from '../utils/DialogUtil';
import { StorageUtil } from '../utils/StorageUtil';
import { Preferences } from '../constant/Preferences';
import { Router } from '../route/Router';
import { RoutePath } from '../route/RoutePath';
import showToast from '../utils/ToastUtil'
import AxiosHttpRequest, { errorHandler } from './AxiosHttpRequest'


/**
 * axios请求客户端创建
 */
const axiosClient = new AxiosHttpRequest({
  baseURL: "https://www.baidu.com/",
  timeout: 10 * 1000,
  checkResultCode: false,
  headers: {
    'Content-Type': 'application/json'
  } as AxiosRequestHeaders,
  interceptorHooks: {
    requestInterceptor: async (config) => {
      // 在发送请求之前做一些处理，例如打印请求信息
      logd('网络请求Request 请求方法:', `${config.method}`);
      logd('网络请求Request 请求链接:', `${config.url}`);
      logjson(config.params, '网络请求Request Params');
      logjson(config.data, '网络请求Request Data');
      axiosClient.config.showLoading = config.showLoading
      if (config.showLoading) {
        showLoadingDialog("加载中...")
      }
      if (config.checkLoginState) {
        let hasLogin = await StorageUtil.get(Preferences.USER_LOGIN, false)
        logd('网络请求Request 登录状态校验>>>', `${hasLogin.toString()}`);
        if (hasLogin) {
          return config
        } else {
          if (config.needJumpToLogin) {
            Router.push(RoutePath.Login)
          }
          throw new AxiosError("请登录")
        }
      }
      return config;
    },
    requestInterceptorCatch: (err) => {
      loge("网络请求RequestError", err.toString())
      if (axiosClient.config.showLoading) {
        hideLoadingDialog()
      }
      return err;
    },
    responseInterceptor: (response) => {
      //优先执行自己的请求响应拦截器，在执行通用请求request的
      if (axiosClient.config.showLoading) {
        hideLoadingDialog()
      }
      logjson(response.data, '网络请求响应Response')
      if (response.status === 200) {
        // @ts-ignore
        const checkResultCode = response.config.checkResultCode
        if (checkResultCode && response.data.errorCode != 0) {
          showToast(response.data.errorMsg)
          return Promise.reject(response)
        }
        return Promise.resolve(response.data);
      } else {
        return Promise.reject(response);
      }
    },
    responseInterceptorCatch: (error) => {
      if (axiosClient.config.showLoading) {
        hideLoadingDialog()
      }
      loge("网络请求响应异常", error.toString())
      errorHandler(error);
      return Promise.reject(error);
    },
  }
});

export default axiosClient;
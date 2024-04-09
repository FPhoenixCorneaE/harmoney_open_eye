import axios, {
  AxiosInstance,
  AxiosRequestConfig,
  AxiosRequestHeaders,
  AxiosResponse,
  InternalAxiosRequestConfig,
  AxiosError,
} from "@ohos/axios";
import { loge } from '../utils/LogUtil';
import showToast from '../utils/ToastUtil';


/**
 * 封装后，不支持传入拦截器
 * 需要自己定义接口继承 AxiosRequestConfig类型
 * 从而支持传入拦截器，但拦截器选项应为可选属性
 * 之后请求实例传入的options为继承了AxiosRequestConfig的自定义类型
 */
interface InterceptorHooks {
  requestInterceptor?: (config: HttpRequestConfig) => Promise<HttpRequestConfig>;
  requestInterceptorCatch?: (error: any) => any;
  // @ts-ignore
  responseInterceptor?: (response: AxiosResponse) => AxiosResponse | Promise<AxiosResponse>;
  responseInterceptorCatch?: (error: any) => any;
}


/**
 * 这里主要是高版本的axios中设置拦截器的时候里面的Config属性必须是InternalAxiosRequestConfig，但是InternalAxiosRequestConfig里面的headers是必传，所以在实现的子类设置成非必传会报错，加了个忽略注解
 */
// @ts-ignore
interface HttpRequestConfig extends InternalAxiosRequestConfig {
  showLoading?: boolean; // 是否展示请求loading
  checkResultCode?: boolean; // 是否检验响应结果码
  checkLoginState?: boolean // 校验用户登陆状态
  needJumpToLogin?: boolean // 是否需要跳转到登陆页面
  interceptorHooks?: InterceptorHooks;
  // @ts-ignore
  headers?: AxiosRequestHeaders
}

/**
 * 网络请求构造
 * 基于axios框架实现
 */
class AxiosHttpRequest {
  config: HttpRequestConfig;
  interceptorHooks?: InterceptorHooks;
  // @ts-ignore
  instance: AxiosInstance;

  constructor(options: HttpRequestConfig) {
    this.config = options;
    this.interceptorHooks = options.interceptorHooks;
    // 创建实例
    this.instance = axios.create(options);
    this.setupInterceptor()
  }

  setupInterceptor(): void {
    this.instance.interceptors.request.use(
      // @ts-ignore
      this.interceptorHooks?.requestInterceptor,
      this.interceptorHooks?.requestInterceptorCatch,
    );
    this.instance.interceptors.response.use(
      this.interceptorHooks?.responseInterceptor,
      this.interceptorHooks?.responseInterceptorCatch,
    );
  }

  // 类型参数的作用，T决定AxiosResponse实例中data的类型
  request<T = any>(config?: HttpRequestConfig): Promise<T> {
    return new Promise<T>((resolve, reject) => {
      this.instance
        // 发送请求
        .request<any, T>(config)
        .then(res => {
          resolve(res);
        })
        .catch((err) => {
          loge("网络请求Request异常：", err.message)
          errorHandler(err)
          if (err) {
            reject(err);
          }
        });
    });
  }

  /**
   * 发送get请求
   * @param config
   * @returns
   */
  get<T = any>(config?: HttpRequestConfig): Promise<T> {
    return this.request({ ...config, method: 'GET' });
  }

  /**
   * 发送post请求
   * @param config
   * @returns
   */
  post<T = any>(config?: HttpRequestConfig): Promise<T> {
    return this.request({ ...config, method: 'POST' });
  }

  /**
   * 发送delete请求
   * @param config
   * @returns
   */
  delete<T = any>(config?: HttpRequestConfig): Promise<T> {
    return this.request({ ...config, method: 'DELETE' });
  }

  /**
   * 发送put请求
   * @param config
   * @returns
   */
  patch<T = any>(config?: HttpRequestConfig): Promise<T> {
    return this.request({ ...config, method: 'PATCH' });
  }
}

export default AxiosHttpRequest

export function errorHandler(error: any) {
  if (error instanceof AxiosError) {
    showToast(error.message)
  } else if (error != undefined && error.response != undefined && error.response.status) {
    switch (error.response.status) {
    // 401: 未登录
    // 未登录则跳转登录页面，并携带当前页面的路径
    // 在登录成功后返回当前页面，这一步需要在登录页操作。
      case 401:
        break;
    // 403 token过期
    // 登录过期对用户进行提示
    // 清除本地token和清空vuex中token对象
    // 跳转登录页面

      case 403:
        showToast("登录过期，请重新登录")
      // 清除token
      // localStorage.removeItem('token');
        break;

    // 404请求不存在
      case 404:
        showToast("网络请求不存在")
        break;

    // 其他错误，直接抛出错误提示
      default:
        showToast(error.response.data.message)
    }
  }
}
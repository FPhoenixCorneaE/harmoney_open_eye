import { HomeModel } from '../model/HomeModel'
import axiosClient from './AxiosClient'

let baseUrl = "https://baobab.kaiyanapp.com/"

export class ApiService {
  getHomeRecommend() {
    return axiosClient.get<HomeModel>({
      url: baseUrl + "api/v5/index/tab/allRec",
      showLoading: true,
    })
  }
}

let apiService = new ApiService()

export default apiService as ApiService
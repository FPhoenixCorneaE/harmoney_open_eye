import { HomeModel } from '../model/HomeModel'
import axiosClient from './AxiosClient'

export const baseUrl = "https://baobab.kaiyanapp.com/"

export class ApiService {

  getHomeData(url: string) {
    return axiosClient.get<HomeModel>({
      url: url,
      showLoading: true,
    })
  }
}

let apiService = new ApiService()

export default apiService as ApiService
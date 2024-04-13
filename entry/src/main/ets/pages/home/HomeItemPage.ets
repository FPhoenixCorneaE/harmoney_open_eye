import { CommonConstants } from '../../constant/CommonConstants'
import { ItemList } from '../../model/HomeModel'
import indexViewModel from '../../viewmodel/IndexViewModel'
import { HomeItem } from './HomeItem'

@Entry
@Component
export struct HomeItemPage {
  private url: string = null
  private nextPageUrl?: string = null
  @State isRefreshing: boolean = false
  @State datas: ItemList[] = []

  aboutToAppear() {
    this.nextPageUrl = this.url
    this.getNetworkData()
  }

  getNetworkData() {
    if (this.nextPageUrl != null) {
      indexViewModel.getHomeData(this.nextPageUrl, (result) => {
        this.nextPageUrl = result.nextPageUrl
        if (this.isRefreshing) {
          this.datas = result.itemList
        } else {
          this.datas = [...this.datas, ...result.itemList]
        }
        this.isRefreshing = false
      })
    }
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing, offset: 100, friction: 100 }) {
      List({ space: 10, initialIndex: 0 }) {
        ForEach(this.datas, (item: ItemList, index: number) => {
          ListItem() {
            HomeItem({ item: item })
          }
        })
      }
      .width(CommonConstants.MATCH_PARENT)
      .height(CommonConstants.MATCH_PARENT)
      // 排列方向
      .listDirection(Axis.Vertical)
      // 每行之间的分界线
      .divider({
        strokeWidth: 0,
        color: Color.Transparent,
        startMargin: 0,
        endMargin: 0
      })
      .onReachEnd(() => {
        this.getNetworkData()
      })
    }.onRefreshing(() => {
      this.nextPageUrl = this.url
      this.getNetworkData()
    })
  }
}
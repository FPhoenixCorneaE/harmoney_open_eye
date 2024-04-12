import { CommonConstants } from '../../constant/CommonConstants'
import { ItemList } from '../../model/HomeModel'
import indexViewModel from '../../viewmodel/IndexViewModel'
import { TextCardFooter2 } from './TextCardFooter2'
import { TextCardFooter3 } from './TextCardFooter3'
import { TextCardHeader5 } from './TextCardHeader5'
import { TextCardHeader7 } from './TextCardHeader7'

@Entry
@Component
export struct RecommendPage {
  private nextPageUrl?: string = null
  @State isRefreshing: boolean = false
  @State datas: ItemList[] = []

  aboutToAppear() {
    this.getNetworkData()
  }

  getNetworkData() {
    indexViewModel.getHomeRecommend(this.nextPageUrl, (result) => {
      this.nextPageUrl = result.nextPageUrl
      if (this.isRefreshing) {
        this.datas = result.itemList
      } else {
        this.datas = [...this.datas, ...result.itemList]
      }
      this.isRefreshing = false
    })
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing, offset: 100, friction: 100 }) {
      List({ space: 10, initialIndex: 0 }) {
        ForEach(this.datas, (item: ItemList, index: number) => {
          ListItem() {
            if (item.type == "textCard") {
              if (item.data.type == "header5") {
                TextCardHeader5({ data: item })
              } else if (item.data.type == "header7" || item.data.type == "header8") {
                TextCardHeader7({ data: item })
              } else if (item.data.type == "footer2") {
                TextCardFooter2({ data: item })
              } else if (item.data.type == "footer3") {
                TextCardFooter3({ data: item })
              }
            }
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
      this.nextPageUrl = null
      this.getNetworkData()
    })
  }
}
import { CommonConstants } from '../../constant/CommonConstants'
import { ItemList } from '../../model/HomeModel'
import indexViewModel from '../../viewmodel/IndexViewModel'
import { TextCardHeader5 } from './TextCardHeader5'

@Entry
@Component
export struct RecommendPage {
  @State isRefreshing: boolean = false
  @State datas: ItemList[] = []

  aboutToAppear() {
    this.getNetworkData()
  }

  getNetworkData() {
    indexViewModel.getHomeRecommend((result) => {
      if (this.isRefreshing) {
        this.datas = result.itemList
      } else {
        this.datas = [...this.datas, ...result.itemList]
      }
      this.isRefreshing = false
    })
  }

  build() {
    Refresh({ refreshing: this.isRefreshing, offset: 200, friction: 88 }) {
      List({ space: 10, initialIndex: 0 }) {
        ForEach(this.datas, (item: ItemList, index: number) => {
          ListItem() {
            if (item.type == "textCard") {
              if (item.data.type == "header5") {
                TextCardHeader5({ data: item })
              }
            }
          }
        })
      }
      .width(CommonConstants.MATCH_PARENT)
      .height(CommonConstants.MATCH_PARENT)
    }
  }
}
import window from '@ohos.window'
import { CommonConstants } from '../../constant/CommonConstants'
import { materialContainderTop } from 'recycler_view_pager'
import { RecommendPage } from '../home/RecommendPage'
import { DiscoveryPage } from '../home/DiscoveryPage'
import { DailyPage } from '../home/DailyPage'
import display from '@ohos.display'

/**
 * 首页
 */
@Entry
@Component
export struct HomePage {
  private titles = ["发现", "推荐", "日报"]
  public controller: TabsController = new TabsController()
  @State model: materialContainderTop.Model = new materialContainderTop.Model(this.controller)
  @State statusHeight: number = 0
  @State index: number = 1
  @State y0: number = 0
  @State x0: number = 0
  @State tmpX: number = 0
  @State tmpY: number = 0
  @State offsetY: number = 0
  @State offsetX: number = 0
  @State timeDown: number = 0
  @State timeUp: number = 0
  @State barIsHidden: boolean = false
  @State titleHeight: number = 8

  aboutToAppear() {
    window.getLastWindow(getContext(this), (error, data) => {
      // 1、获取系统状态栏
      let avoidArea = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      // 2、获取系统返回的状态栏高度
      this.statusHeight = px2vp(avoidArea.topRect.height)
    })
    this.model
      .setViewWidth(display.getDefaultDisplaySync().width)
      .setTextHeight(40)
      .setSelectTextColor("#444444")
      .setSelectTextSize(18)
      .setUnselectedTextColor("#888888")
      .setUnselectedTextSize(16)
      .setSnap(true)
      .setBackgroundColor("#ffffff")
      .setDividerColor("#ededed")
      .setDividerHeight(1)
      .setCursorWidth(12)
      .setCursorHeight(3)
      .setCursorRadius(3)
      .setCursorColor("#444444")
  }

  build() {
    Column() {
      this.SearchBox()
      materialContainderTop({ index: $index, model: $model, titles: this.titles})
      Tabs({ index: this.index, controller: this.controller }) {
        TabContent() {
          // 发现
          DiscoveryPage()
        }

        TabContent() {
          // 推荐
          RecommendPage()
        }

        TabContent() {
          // 日报
          DailyPage()
        }
      }
      .width(CommonConstants.MATCH_PARENT)
      .height(CommonConstants.MATCH_PARENT)
      .onChange((index) => {
        this.index = index
      })
      .barWidth(0)
      .barHeight(0)
      .onTouch((event: TouchEvent) => {
        this.model.notifyTouch(event, this.index)
        this.onTouchEvent(event)
      })
    }
    .width(CommonConstants.MATCH_PARENT)
    .height(CommonConstants.MATCH_PARENT)
  }

  onTouchEvent(event: TouchEvent) {
    if (event.type == TouchType.Down) {
      this.y0 = event.touches[0].screenY
      this.x0 = event.touches[0].screenX
    }
    if (event.type == TouchType.Move) {
      this.tmpX = this.x0 - event.touches[0].screenX;
      this.tmpY = this.y0 - event.touches[0].screenY;

      if (Math.abs(this.tmpY) > Math.abs(this.tmpX)) {
        if (this.tmpY > 0 && !this.barIsHidden) {
          // 向上滑动，折叠
          if (this.tmpY <= 8 * 25) {
            this.offsetY = this.tmpY;
          } else {
            this.barIsHidden = true;
          }
        } else if (this.tmpY < 0 && this.barIsHidden) {
          // 向下滑动
          if (Math.abs(this.tmpY) <= 8 * 25 * 0.5) {
            this.offsetY = this.tmpY;
          } else {
            this.barIsHidden = false;
          }
        }
      } else {
        this.offsetX = this.tmpX;
      }

      this.titleHeight = (8 - (this.offsetY >= 0 && this.offsetY / 25 < 8 ? this.offsetY / 25 :
        (this.offsetY < 0 && (-this.offsetY / 25) < 8 ? (-(this.offsetY / 25) * (25 / this.offsetY)) : // 下拉
            this.offsetY < 0 ? 0 : 8) // 下拉后固定
      ))
    }

    if (event.type == TouchType.Up) {
      if (Math.abs(this.tmpY) > Math.abs(this.tmpX)) {
        if (this.tmpY > 0 && !this.barIsHidden) {
          // 向上滑动，折叠
          if (this.tmpY >= 8 * 25 * 0.5) {
            this.offsetY += (8 * 25 - this.offsetY);
            this.barIsHidden = true;
          } else {
            this.offsetY = 0;
          }
        } else if (this.tmpY < 0 && this.barIsHidden) {
          // 向下滑动
          if (Math.abs(this.tmpY) >= 8 * 25 * 0.5) {
            this.barIsHidden = false;
          }
        }
      }

      this.titleHeight = (8 - (this.offsetY >= 0 && this.offsetY / 25 < 8 ? this.offsetY / 25 :
        (this.offsetY < 0 && (-this.offsetY / 25) < 8 ? (-(this.offsetY / 25) * (25 / this.offsetY)) : // 下拉
            this.offsetY < 0 ? 0 : 8) // 下拉后固定
      ))

      if (this.titleHeight >= 8) {
        this.titleHeight = 8;
      } else if (this.titleHeight < 8 * 0.2) {
        this.titleHeight = 0;
      }
    }
  }

  @Builder
  SearchBox() {
    Row() {
      Row({ space: 12 }) {
        Image($r("app.media.ic_search")).size({ width: 20, height: 20 })
        Text($r("app.string.search_hint"))
          .fontSize("16fp")
          .fontColor("#999999")
      }
      .layoutWeight(1)
      .height(50)
      .backgroundColor($r("app.color.white"))
      .borderRadius(36)
      .shadow({ radius: 20, color: "#e4e4e4" })
      .margin({ left: 20, right: 20 })
      .padding({ left: 16, right: 16 })
      .alignItems(VerticalAlign.Center)
    }
    .margin({ top: this.statusHeight })
    .width(CommonConstants.MATCH_PARENT)
    .height(74)
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }
}
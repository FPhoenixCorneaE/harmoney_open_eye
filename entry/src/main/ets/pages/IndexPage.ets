import curves from '@ohos.curves'
import emitter from '@ohos.events.emitter'
import font from '@ohos.font'
import { CommonConstants } from '../constant/CommonConstants'
import { EventKey } from '../event/Event'
import { LoadingDialogEvent } from '../event/LoadingDialogEvent'
import { resource2String } from '../utils/ResourceUtil'
import indexViewModel, { IndexTab } from '../viewmodel/IndexViewModel'
import { LoadingDialog } from '../widget/LoadingDialog'
import { HomePage } from './index/HomePage'


/**
 * App主界面
 */
@Entry
@Component
struct IndexPage {
  @State selectedIndex: number = 0
  @State homeIconScale: number = 1
  @State loadingTips: string = "加载中..."
  @State isShowLoading: boolean = false
  /** 加载弹窗 */
  private loadingDialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ loadingTips: this.loadingTips }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    autoCancel: false,
    customStyle: true,
    cancel: () => {
      this.isShowLoading = false
    }
  })

  aboutToAppear() {
    // font.registerFont({
    //   familyName: resource2String($r("app.string.font_family_name_fz_lan_ting_hei_s_db1_gb_regular")),
    //   familySrc: resource2String($r("app.string.font_family_src_fz_lan_ting_hei_s_db1_gb_regular"))
    // })
    emitter.on(LoadingDialogEvent, (event) => {
      if (event.data.showLoading == true && !this.isShowLoading) {
        this.isShowLoading = true
        this.loadingTips = event.data.loadingTips
        this.loadingDialogController.open()
      } else if (event.data.showLoading == false) {
        this.isShowLoading = false
        this.loadingDialogController.close()
      }
    })
  }

  aboutToDisappear() {
    this.loadingDialogController = null
    emitter.off(EventKey.LOADING_DIALOG)
  }

  onPageShow() {
    console.debug("onPageShow()：》》》》》》页面可见")
  }

  onPageHide() {
    console.debug("onPageHide()：》》》》》》页面不可见")
  }

  build() {
    Column() {
      Tabs({
        index: this.selectedIndex,
        barPosition: BarPosition.End,
      }) {
        ForEach(indexViewModel.indexTabs, (item, index) => {
          TabContent() {
            if (index == 0) {
              HomePage()
            } else if (index == 1) {
            } else if (index == 2) {
            } else {
            }
          }.tabBar(this.TabItemBuilder(item, index))
        })
      }
      .barMode(BarMode.Fixed)
      .scrollable(false)
      .barWidth(CommonConstants.MATCH_PARENT)
      .barHeight($r("app.float.index_tab_bar_height"))
      .onChange((index: number) => {
        if (this.selectedIndex != index) {
          this.selectedIndex = index
          if (index == 0) {
            // 首页Tab缩放动画
            this.homeIconScale = 0
            animateTo(
              { duration: 400, curve: curves.springCurve(10, 1, 1, 1.2) },
              () => {
                this.homeIconScale = 1
              })
          }
        }
      })
    }.width(CommonConstants.MATCH_PARENT)
    .height(CommonConstants.MATCH_PARENT)
  }

  @Builder
  TabItemBuilder(item: IndexTab, index: number) {
    Stack({ alignContent: Alignment.Top }) {
      Column({
        space: "4vp"
      }) {
        Image(this.selectedIndex == index ? item.iconActive : item.iconOriginal)
          .height($r("app.float.index_tab_icon_size"))
          .width($r("app.float.index_tab_icon_size"))
          .scale({
            x: this.selectedIndex == index ? this.homeIconScale : 1,
            y: this.selectedIndex == index ? this.homeIconScale : 1,
            centerX: CommonConstants.HALF_PARENT,
            centerY: CommonConstants.HALF_PARENT,
          })
        Text(item.title)
          .fontSize($r("app.float.index_tab_text_size"))
          .fontWeight(this.selectedIndex === index ? FontWeight.Regular : FontWeight.Normal)
          .fontColor(this.selectedIndex === index ? $r("app.color.color_444444") : $r("app.color.color_888888"))
          .textAlign(TextAlign.Center)
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .height(CommonConstants.MATCH_PARENT)
      .width(CommonConstants.MATCH_PARENT)
      .backgroundColor($r("app.color.white"))
      // 分割线
      Divider().strokeWidth("0.8vp").color($r("app.color.divider_adadad")).width(CommonConstants.MATCH_PARENT)
    }
  }
}
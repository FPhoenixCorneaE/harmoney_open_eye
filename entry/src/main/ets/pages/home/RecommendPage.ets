import emitter from '@ohos.events.emitter'
import { LoadingDialogEvent } from '../../event/LoadingDialogEvent'
import { LoadingDialogModel } from '../../event/model/LoadingDialogModel'

@Entry
@Component
export struct RecommendPage {
  @State message: string = 'RecommendPage'

  aboutToAppear() {
    emitter.emit(LoadingDialogEvent, LoadingDialogModel(true))
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}
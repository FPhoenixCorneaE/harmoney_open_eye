import { RoutePath } from '../route/RoutePath'
import { Router } from '../route/Router'

/**
 * 启动页
 */
@Entry
@Component
struct SplashPage {
  aboutToAppear() {
    setTimeout(() => {
      Router.replace(RoutePath.Index)
    }, 2000)
  }

  build() {
    Stack() {
      Image($r("app.media.img_splash")).objectFit(ImageFit.ScaleDown)
    }
    .width('100%')
    .height('100%')
  }
}
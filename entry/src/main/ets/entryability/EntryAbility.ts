import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // 1.获取应用主窗口。
    let windowClass = null;
    windowStage.getMainWindow((err, data) => {

      if (err.code) {
        console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
        return;
      }

      windowClass = data;
      console.info('Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));

      // 2.实现沉浸式效果：设置状态栏沉浸，导航栏不显示。
      let names: Array<'status' | 'navigation'> = ["status"];
      windowClass.setWindowSystemBarEnable(names, (err) => {
        if (err.code) {
          console.error('Failed to set the system bar to be visible. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in setting the system bar to be visible.');
      });
      windowClass.setWindowLayoutFullScreen(true)
    })

    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/SplashPage', (err, data) => {

      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}

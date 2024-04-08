/**
 * 主页ViewModel
 */
class IndexViewModel {
  /** 主界面底部标签 */
  indexTabs = [
    new IndexTab("首页", $r("app.media.ic_tab_homepage_selected"), $r("app.media.ic_tab_homepage_normal")),
    new IndexTab("社区", $r("app.media.ic_tab_community_selected"), $r("app.media.ic_tab_community_normal")),
    new IndexTab("通知", $r("app.media.ic_tab_notification_selected"), $r("app.media.ic_tab_notification_normal")),
    new IndexTab("我的", $r("app.media.ic_tab_me_selected"), $r("app.media.ic_tab_me_normal")),
  ]
}

/**
 * 主页底部标签
 */
export class IndexTab {
  title: string;
  iconActive: Resource;
  iconOriginal: Resource;

  constructor(title: string, iconActive: Resource, iconOriginal: Resource) {
    this.title = title
    this.iconActive = iconActive
    this.iconOriginal = iconOriginal
  }
}

let indexViewModel = new IndexViewModel();

export default indexViewModel as IndexViewModel;
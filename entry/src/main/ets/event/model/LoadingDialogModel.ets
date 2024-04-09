/**
 * 展示LoadingDialog的Model
 * @param showLoading
 * @param "
 * @returns
 */
export function LoadingDialogModel(showLoading: boolean, loadingTips: string = "加载中...") {
  return {
    data: {
      "showLoading": showLoading,
      "loadingTips": loadingTips
    }
  }
}

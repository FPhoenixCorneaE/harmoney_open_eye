import emitter from '@ohos.events.emitter'
import { LoadingDialogEvent } from '../event/LoadingDialogEvent'
import { LoadingDialogModel } from '../event/model/LoadingDialogModel'

/**
 * 显示loading
 * @param tips
 */
export function showLoadingDialog(tips: string = "加载中") {
  emitter.emit(LoadingDialogEvent, LoadingDialogModel(true, tips))
}

/**
 * 隐藏loading
 */
export function hideLoadingDialog() {
  emitter.emit(LoadingDialogEvent, LoadingDialogModel(false, ""))
}
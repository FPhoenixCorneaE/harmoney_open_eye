import hilog from '@ohos.hilog';

const prefix = "OpenEye"
const format = `%{public}s, %{public}s`
const domain = 0x0000

export function logd(...args: string[]) {
  hilog.debug(domain, prefix, format, args);
}

export function logi(...args: string[]) {
  hilog.info(domain, prefix, format, args);
}

export function logw(...args: string[]) {
  hilog.warn(domain, prefix, format, args);
}

export function loge(...args: string[]) {
  hilog.error(domain, prefix, format, args);
}

export function logf(...args: string[]) {
  hilog.fatal(domain, prefix, format, args);
}
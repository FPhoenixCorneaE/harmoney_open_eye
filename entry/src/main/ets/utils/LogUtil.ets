import hilog from '@ohos.hilog';

const prefix = "OpenEye"
const format = `%{public}s, %{public}s`
const domain = 0x0000

export class LogUtil {
  static debug(...args: string[]) {
    hilog.debug(domain, prefix, format, args);
  }

  static info(...args: string[]) {
    hilog.info(domain, prefix, format, args);
  }

  static warn(...args: string[]) {
    hilog.warn(domain, prefix, format, args);
  }

  static error(...args: string[]) {
    hilog.error(domain, prefix, format, args);
  }

  static fatal(...args: string[]) {
    hilog.fatal(domain, prefix, format, args);
  }
}
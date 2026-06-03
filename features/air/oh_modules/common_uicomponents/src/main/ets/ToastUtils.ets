// Toast工具
// 查拉图斯特拉如是说

import { promptAction } from '@kit.ArkUI'

export class ToastUtils {
  static show(message: string, duration: number = 2000): void {
    promptAction.showToast({
      message: message,
      duration: duration
    })
  }

  static showShort(message: string): void {
    ToastUtils.show(message, 1500)
  }

  static showLong(message: string): void {
    ToastUtils.show(message, 3000)
  }
}
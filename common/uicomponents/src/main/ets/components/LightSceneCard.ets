// 灯光场景卡片 - 横向滚动布局
// 查拉图斯特拉如是说

import { ToastUtils } from '../ToastUtils.ets'

@ComponentV2
export struct LightSceneCard {
  @Param selectIcon: ResourceStr = ''
  @Param unselectIcon: ResourceStr = ''
  @Param title: string = ''
  @Param isSelected: boolean = false
  @Param isEnabled: boolean = true
  @Param disabledHint: string = '请先开启灯光总开关'
  @Param onClickHandler: () => void = () => {}

  build() {
    Column() {
      Image(this.isSelected ? this.selectIcon : this.unselectIcon)
        .width(140)
        .height(140)

      Text(this.title)
        .fontColor('#F5D08A')
        .fontSize(16)
        .margin({ top: 8 })
    }
    .width(120)
    .height(180)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#10264A')
    .borderRadius(24)
    .onClick(() => {
      if (this.isEnabled) {
        this.onClickHandler()
      } else {
        ToastUtils.show(this.disabledHint)
      }
    })
  }
}
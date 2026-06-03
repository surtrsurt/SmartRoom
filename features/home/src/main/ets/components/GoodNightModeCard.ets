//晚安模式卡片
//查拉图斯特拉如是说

import { ToastUtils } from 'common_uicomponents'

@ComponentV2
export struct GoodNightModeCard {
  @Param goodNightModeOn: boolean = false
  @Param onToggle: () => void = () => {}

  build() {
    Column() {
      Text('晚安模式')
        .fontSize(18)
        .fontWeight(600)
        .fontColor('#FFFFFF')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 16 })

      Row() {
        Column() {
          Image(this.goodNightModeOn ? $r('app.media.home_good_night_mode_select') : $r('app.media.home_good_night_mode_unselect'))
            .width(80)
            .height(80)
          Text(this.goodNightModeOn ? '已开启' : '已关闭')
            .fontSize(12)
            .fontColor(this.goodNightModeOn ? '#FACC15' : '#FFFFFF')
            .margin({ top: 4 })
        }
        .flexGrow(1)
        .height(100)
        .borderRadius(24)
        .backgroundColor(this.goodNightModeOn ? 'rgba(250,204,21,0.2)' : 'rgba(30,30,30,0.5)')
        .borderWidth(1)
        .borderColor(this.goodNightModeOn ? '#FACC15' : 'rgba(250,204,21,0.4)')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.onToggle()
          ToastUtils.show(this.goodNightModeOn ? '晚安模式已关闭' : '晚安模式已开启')
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(7,27,64,0.6)')
    .borderRadius(24)
    .border({ width: 1, color: 'rgba(255,255,255,0.2)' })
    .backdropBlur(15)
    .shadow({ radius: 10, color: 'rgba(0,0,0,0.2)', offsetX: 0, offsetY: 4 })
  }
}
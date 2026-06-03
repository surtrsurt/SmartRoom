//夜灯卡片
//查拉图斯特拉如是说

import { ToastUtils } from 'common_uicomponents'

@ComponentV2
export struct NightLightCard {
  @Param leftOn: boolean = false
  @Param rightOn: boolean = false
  @Param onLeftToggle: () => void = () => {}
  @Param onRightToggle: () => void = () => {}

  build() {
    Column() {
      Text('夜灯')
        .fontSize(18)
        .fontWeight(600)
        .fontColor('#FFFFFF')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 16 })

      Row() {
        Column() {
          Image(this.leftOn ? $r('app.media.home_icon_night_left_select') : $r('app.media.home_icon_night_left_unselect'))
            .width(80)
            .height(80)
          Text('左夜灯')
            .fontSize(12)
            .fontColor(this.leftOn ? '#FACC15' : '#FFFFFF')
            .margin({ top: 4 })
        }
        .flexGrow(1)
        .height(100)
        .borderRadius(24)
        .backgroundColor(this.leftOn ? 'rgba(250,204,21,0.2)' : 'rgba(30,30,30,0.5)')
        .borderWidth(1)
        .borderColor(this.leftOn ? '#FACC15' : 'rgba(250,204,21,0.4)')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.onLeftToggle()
        })

        Row()
          .width(1)
          .height(40)
          .backgroundColor('rgba(250,204,21,0.3)')

        Column() {
          Image(this.rightOn ? $r('app.media.home_icon_night_right_select') : $r('app.media.home_icon_night_right_unselect'))
            .width(80)
            .height(80)
          Text('右夜灯')
            .fontSize(12)
            .fontColor(this.rightOn ? '#FACC15' : '#FFFFFF')
            .margin({ top: 4 })
        }
        .flexGrow(1)
        .height(100)
        .borderRadius(24)
        .backgroundColor(this.rightOn ? 'rgba(250,204,21,0.2)' : 'rgba(30,30,30,0.5)')
        .borderWidth(1)
        .borderColor(this.rightOn ? '#FACC15' : 'rgba(250,204,21,0.4)')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.onRightToggle()
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
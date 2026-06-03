//服务状态栏
//查拉图斯特拉如是说

import { ToastUtils } from 'common_uicomponents'

@ComponentV2
export struct ServiceStatusBar {
  @Param disturbMode: boolean = false
  @Param cleanRoom: boolean = false
  @Param onDisturbToggle: () => void = () => {}
  @Param onCleanRoomToggle: () => void = () => {}

  build() {
    Row() {
      Text('服务快捷')
        .fontSize(18)
        .fontWeight(600)
        .fontColor('#FFFFFF')
        .width(120)
        .textAlign(TextAlign.Start)

      Row() {
        Column() {
          Image($r('app.media.home_icon_undisturb'))
            .width(60)
            .height(60)
          Text('请勿打扰')
            .fontSize(12)
            .fontColor(this.disturbMode ? '#FACC15' : '#FFFFFF')
            .margin({ top: 4 })
        }
        .flexGrow(1)
        .height(80)
        .borderRadius(24)
        .backgroundColor(this.disturbMode ? 'rgba(250,204,21,0.2)' : 'rgba(30,30,30,0.5)')
        .borderWidth(1)
        .borderColor(this.disturbMode ? '#FACC15' : 'rgba(250,204,21,0.4)')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.onDisturbToggle()
          ToastUtils.show(this.disturbMode ? '请勿打扰已关闭' : '请勿打扰已开启')
        })

        Column() {
          Image($r('app.media.home_icon_clear'))
            .width(60)
            .height(60)
          Text('清理房间')
            .fontSize(12)
            .fontColor(this.cleanRoom ? '#FACC15' : '#FFFFFF')
            .margin({ top: 4 })
        }
        .flexGrow(1)
        .height(80)
        .borderRadius(24)
        .backgroundColor(this.cleanRoom ? 'rgba(250,204,21,0.2)' : 'rgba(30,30,30,0.5)')
        .borderWidth(1)
        .borderColor(this.cleanRoom ? '#FACC15' : 'rgba(250,204,21,0.4)')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .margin({ left: 12 })
        .onClick(() => {
          this.onCleanRoomToggle()
          ToastUtils.show(this.cleanRoom ? '清理房间已取消' : '清理房间已预约')
        })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
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
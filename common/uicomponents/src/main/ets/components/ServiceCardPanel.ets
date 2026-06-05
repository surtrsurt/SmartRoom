// 服务卡片面板 - 请勿打扰+清理房间
// 查拉图斯特拉如是说

@ComponentV2
export struct ServiceCardPanel {
  @Param disturbSelected: boolean = false
  @Param cleanRoomSelected: boolean = false
  @Param onDisturbToggle: () => void = () => {}
  @Param onCleanRoomToggle: () => void = () => {}

  build() {
    Row({ space: 16 }) {
      // 请勿打扰
      Column() {
        Image($r('app.media.home_icon_undisturb'))
          .width(100)
          .height(100)

        Text('请勿打扰')
          .fontSize(24)
          .fontColor(this.disturbSelected ? '#DDB97A' : '#F4D39A')
          .margin({ top: 8 })
      }
      .width('48%')
      .height(160)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.disturbSelected ? 'rgba(255,215,120,0.12)' : 'rgba(0,0,0,0.2)')
      .borderRadius(16)
      .border({
        width: 1,
        color: this.disturbSelected ? '#DDB97A' : 'rgba(221,185,122,0.3)'
      })
      .onClick(() => this.onDisturbToggle())

      // 清理房间
      Column() {
        Image($r('app.media.home_icon_clear'))
          .width(100)
          .height(100)

        Text('清理房间')
          .fontSize(24)
          .fontColor(this.cleanRoomSelected ? '#DDB97A' : '#F4D39A')
          .margin({ top: 8 })
      }
      .width('48%')
      .height(160)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.cleanRoomSelected ? 'rgba(255,215,120,0.12)' : 'rgba(0,0,0,0.2)')
      .borderRadius(16)
      .border({
        width: 1,
        color: this.cleanRoomSelected ? '#DDB97A' : 'rgba(221,185,122,0.3)'
      })
      .onClick(() => this.onCleanRoomToggle())
    }
    .width('100%')
    .height(240)
    .padding(24)
    .backgroundColor('rgba(10,28,65,0.75)')
    .borderRadius(24)
  }
}
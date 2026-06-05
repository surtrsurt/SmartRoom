// 窗帘顶部控制按钮（全部打开/全部关闭）
// 查拉图斯特拉如是说

@ComponentV2
export struct CurtainTopControlCard {
  @Param selectedControl: string = ''
  @Param onOpenAll: () => void = () => {}
  @Param onCloseAll: () => void = () => {}

  build() {
    Row({ space: 12 }) {
      Column() {
        Image($r('app.media.curtain_icon_open_all'))
          .width(120)
          .height(120)
        Text('全部打开')
          .fontSize(18)
          .fontColor(this.selectedControl === 'allOpen' ? '#DDB97A' : '#F4D39A')
          .margin({ top: 8 })
      }
      .width('48%')
      .height(200)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.selectedControl === 'allOpen' ? 'rgba(255,215,120,0.15)' : 'rgba(0,0,0,0.2)')
      .borderRadius(24)
      .border({ width: 1, color: this.selectedControl === 'allOpen' ? '#DDB97A' : 'rgba(221,185,122,0.3)' })
      .onClick(() => this.onOpenAll())

      Column() {
        Image($r('app.media.curtain_icon_close_all'))
          .width(120)
          .height(120)
        Text('全部关闭')
          .fontSize(18)
          .fontColor(this.selectedControl === 'allClose' ? '#DDB97A' : '#F4D39A')
          .margin({ top: 8 })
      }
      .width('48%')
      .height(200)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.selectedControl === 'allClose' ? 'rgba(255,215,120,0.15)' : 'rgba(0,0,0,0.2)')
      .borderRadius(24)
      .border({ width: 1, color: this.selectedControl === 'allClose' ? '#DDB97A' : 'rgba(221,185,122,0.3)' })
      .onClick(() => this.onCloseAll())
    }
    .width('100%')
  }
}
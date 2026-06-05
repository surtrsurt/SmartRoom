// SOS紧急呼叫卡片
// 查拉图斯特拉如是说

@ComponentV2
export struct ServiceSosCard {
  @Param isCalling: boolean = false
  @Param onTap: () => void = () => {}

  build() {
    Row() {
      Row() {
        Image($r('app.media.service_icon_sos'))
          .width(120)
          .height(120)
      }
      .width(120)
      .height(120)
      .backgroundColor(this.isCalling ? 'rgba(255,50,50,0.25)' : 'rgba(255,0,0,0.12)')
      .borderRadius(60)

      Column() {
        Text('SOS 紧急呼叫')
          .fontSize(34)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.isCalling ? '#FF6B6B' : '#F4D39A')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 20 })
    }
    .width('100%')
    .height(140)
    .padding(20)
    .backgroundColor(this.isCalling ? 'rgba(255,50,50,0.25)' : 'rgba(0,30,80,0.92)')
    .borderRadius(24)
    .border({ width: 1, color: this.isCalling ? '#FF4444' : '#6EA8FF' })
    .shadow({
      radius: 25,
      color: this.isCalling ? 'rgba(255,80,80,0.4)' : 'rgba(80,120,255,0.25)'
    })
    .onClick(() => this.onTap())
  }
}
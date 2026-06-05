// 主开关卡片
// 查拉图斯特拉如是说

@ComponentV2
export struct MainSwitchCard {
  @Param isOn: boolean = false
  @Param onToggle: () => void = () => {}

  build() {
    Row() {
      Column() {
        Text('总开关')
          .fontSize(24)
          .fontColor('#F5D08A')
          .fontWeight(FontWeight.Bold)
        Text('一键控制所有灯光')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .margin({ top: 8 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Image(this.isOn ? $r('app.media.light_btn_main_switch_select') : $r('app.media.light_btn_main_switch_unselect'))
        .width(150)
        .height(150)
        .onClick(() => this.onToggle())
    }
    .width('100%')
    .height(140)
    .padding(24)
    .backgroundColor('#091B3B')
    .borderRadius(28)
  }
}
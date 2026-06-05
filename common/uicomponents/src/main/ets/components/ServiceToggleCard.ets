// 服务开关卡片 - 图标+文字+开关按钮
// 查拉图斯特拉如是说

@ComponentV2
export struct ServiceToggleCard {
  @Param icon: ResourceStr = ''
  @Param title: string = ''
  @Param isOn: boolean = false
  @Param onToggleIcon: ResourceStr = 'service_toggle_on'
  @Param offToggleIcon: ResourceStr = 'service_toggle_off'
  @Param onToggleHandler: () => void = () => {}

  build() {
    Column() {
      Image(this.icon)
        .width(100)
        .height(100)

      Text(this.title)
        .fontSize(28)
        .fontColor(this.isOn ? '#DDB97A' : '#F4D39A')
        .margin({ top: 20 })

      Image(this.isOn ? $r(`app.media.${this.onToggleIcon}`) : $r(`app.media.${this.offToggleIcon}`))
        .width(70)
        .height(70)
        .onClick(() => this.onToggleHandler())
        .margin({ top: 30 })
    }
    .width('48%')
    .height(300)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.isOn ? 'rgba(255,215,120,0.15)' : 'rgba(0,30,80,0.92)')
    .borderRadius(24)
    .border({
      width: 1,
      color: this.isOn ? '#DDB97A' : '#6EA8FF'
    })
    .shadow({
      radius: 25,
      color: this.isOn ? 'rgba(255,215,120,0.25)' : 'rgba(80,120,255,0.25)'
    })
  }
}
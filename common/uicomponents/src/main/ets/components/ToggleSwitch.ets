// 开关切换组件
// 查拉图斯特拉如是说

@ComponentV2
export struct ToggleSwitch {
  @Param isOn: boolean = false
  @Param onIcon: ResourceStr = ''
  @Param offIcon: ResourceStr = ''
  @Param label: string = ''
  @Param switchWidth: number = 72
  @Param switchHeight: number = 72
  @Param onClickHandler: () => void = () => {}

  build() {
    Column() {
      Image(this.isOn ? this.onIcon : this.offIcon)
        .width(this.switchWidth)
        .height(this.switchHeight)
        .onClick(() => this.onClickHandler())

      Text(this.label)
        .fontSize(20)
        .fontColor('#F4D39A')
    }
    .onClick(() => this.onClickHandler())
  }
}
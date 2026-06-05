// 图标开关按钮 - 带选中态
// 查拉图斯特拉如是说

@ComponentV2
export struct IconToggleButton {
  @Param selectIcon: ResourceStr = ''
  @Param unselectIcon: ResourceStr = ''
  @Param title: string = ''
  @Param isSelected: boolean = false
  @Param iconWidth: number = 80
  @Param iconHeight: number = 80
  @Param fontSize: number = 18
  @Param onClickHandler: () => void = () => {}

  build() {
    Column() {
      Image(this.isSelected ? this.selectIcon : this.unselectIcon)
        .width(this.iconWidth)
        .height(this.iconHeight)

      Text(this.title)
        .fontSize(this.fontSize)
        .fontColor('#F4D39A')
        .margin({ top: 4 })
    }
    .width('48%')
    .height(160)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.isSelected ? 'rgba(255,215,120,0.12)' : 'rgba(0,0,0,0.2)')
    .borderRadius(16)
    .border({
      width: 1,
      color: this.isSelected ? '#DDB97A' : 'rgba(221,185,122,0.3)'
    })
    .onClick(() => this.onClickHandler())
  }
}
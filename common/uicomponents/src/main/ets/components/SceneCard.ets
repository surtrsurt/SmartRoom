// 场景卡片组件 - 图标+文字+选中态
// 查拉图斯特拉如是说

@ComponentV2
export struct SceneCard {
  @Param selectIcon: ResourceStr = ''
  @Param unselectIcon: ResourceStr = ''
  @Param title: string = ''
  @Param isSelected: boolean = false
  @Param isEnabled: boolean = true
  @Param onClickHandler: () => void = () => {}

  build() {
    Column() {
      Image(this.isSelected ? this.selectIcon : this.unselectIcon)
        .width(110)
        .height(110)

      Text(this.title)
        .fontSize(24)
        .fontColor('#F4D39A')
        .margin({ top: 12 })
    }
    .width('100%')
    .height(160)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.isSelected ? 'rgba(255,215,120,0.15)' : 'rgba(0,0,0,0.2)')
    .borderRadius(20)
    .border({
      width: 1,
      color: this.isSelected ? '#DDB97A' : 'rgba(221,185,122,0.3)'
    })
    .opacity(this.isEnabled ? 1.0 : 0.5)
    .onClick(() => {
      if (this.isEnabled) {
        this.onClickHandler()
      }
    })
  }
}
// 分段按钮组 - 用于空调自动/强劲模式
// 查拉图斯特拉如是说

interface SegmentButtonConfig {
  icon: ResourceStr
  label: string
}

@ComponentV2
export struct SegmentButtonGroup {
  @Param buttons: SegmentButtonConfig[] = []
  @Param selectedIndex: number = -1
  @Param onSelect: (index: number) => void = () => {}

  build() {
    Row({ space: 12 }) {
      ForEach(this.buttons, (button: SegmentButtonConfig, index: number) => {
        Column() {
          Image(button.icon)
            .width(50)
            .height(50)

          Text(button.label)
            .fontSize(20)
            .fontColor('#F4D39A')
            .margin({ top: 8 })
        }
        .width('47%')
        .height(80)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.selectedIndex === index ?
          'rgba(255,215,120,0.12)' : 'rgba(0,0,0,0)')
        .border({
          width: 1,
          color: this.selectedIndex === index ? '#DDB97A' : 'rgba(221,185,122,0.5)'
        })
        .borderRadius(16)
        .onClick(() => this.onSelect(index))
      })
    }
  }
}
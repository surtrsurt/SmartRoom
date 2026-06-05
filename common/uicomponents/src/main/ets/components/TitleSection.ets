// 标题组件 - 带金色分隔线
// 查拉图斯特拉如是说

@ComponentV2
export struct TitleSection {
  @Param title: string = ''
  @Param fontSize: number = 38
  @Param paddingTop: number = 60
  @Param paddingBottom: number = 30

  build() {
    Column() {
      Text(this.title)
        .fontSize(this.fontSize)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F5D8A3')

      Divider()
        .width(80)
        .height(2)
        .color('#D6B16A')
        .margin({ top: 8 })
    }
    .width('100%')
    .padding({
      top: this.paddingTop,
      bottom: this.paddingBottom
    })
  }
}
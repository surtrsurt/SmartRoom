// Loading弹窗
// 查拉图斯特拉如是说

@Component
export struct LoadingDialog {
  @Prop message: string = '加载中...'

  build() {
    Column() {
      LoadingProgress()
        .width(48)
        .height(48)
        .color('#007DFF')
      Text(this.message)
        .fontSize(14)
        .fontColor('#FFFFFF')
        .margin({ top: 16 })
    }
    .width(120)
    .height(120)
    .backgroundColor('rgba(0, 0, 0, 0.75)')
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
// 退出登录卡片
// 查拉图斯特拉如是说

@ComponentV2
export struct ServiceLogoutCard {
  @Param onTap: () => void = () => {}

  build() {
    Row() {
      Image($r('app.media.service_icon_log_out'))
        .width(100)
        .height(100)

      Text('退出登录')
        .fontSize(34)
        .fontWeight(FontWeight.Medium)
        .fontColor('#E8C27F')
        .margin({ left: 20 })

      Blank()
    }
    .width('100%')
    .height(120)
    .padding({ left: 24, right: 24 })
    .backgroundColor('rgba(10,28,65,0.88)')
    .borderRadius(24)
    .border({ width: 1, color: '#CDA15C' })
    .onClick(() => this.onTap())
  }
}
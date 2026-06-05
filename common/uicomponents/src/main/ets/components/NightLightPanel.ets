// 夜灯控制面板 - 左夜灯+右夜灯
// 查拉图斯特拉如是说

@ComponentV2
export struct NightLightPanel {
  @Param leftSelected: boolean = false
  @Param rightSelected: boolean = false
  @Param onLeftToggle: () => void = () => {}
  @Param onRightToggle: () => void = () => {}

  build() {
    Column() {
      Text('夜灯')
        .fontSize(26)
        .fontColor('#F4D39A')
        .width('100%')
        .textAlign(TextAlign.Start)

      Row() {
        // 左夜灯
        Column() {
          Image(this.leftSelected ?
            $r('app.media.home_icon_night_left_select') :
            $r('app.media.home_icon_night_left_unselect'))
            .width(80)
            .height(80)

          Text('左夜灯')
            .fontSize(18)
            .fontColor('#F4D39A')
            .margin({ top: 4 })
        }
        .width('48%')
        .height(140)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.leftSelected ? 'rgba(255,215,120,0.12)' : 'rgba(0,0,0,0.2)')
        .borderRadius(16)
        .border({
          width: 1,
          color: this.leftSelected ? '#DDB97A' : 'rgba(221,185,122,0.3)'
        })
        .onClick(() => this.onLeftToggle())

        Divider()
          .vertical(true)
          .height(80)
          .color('rgba(221,185,122,0.3)')

        // 右夜灯
        Column() {
          Image(this.rightSelected ?
            $r('app.media.home_icon_night_right_select') :
            $r('app.media.home_icon_night_right_unselect'))
            .width(80)
            .height(80)

          Text('右夜灯')
            .fontSize(18)
            .fontColor('#F4D39A')
            .margin({ top: 4 })
        }
        .width('48%')
        .height(140)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.rightSelected ? 'rgba(255,215,120,0.12)' : 'rgba(0,0,0,0.2)')
        .borderRadius(16)
        .border({
          width: 1,
          color: this.rightSelected ? '#DDB97A' : 'rgba(221,185,122,0.3)'
        })
        .onClick(() => this.onRightToggle())
      }
      .height(160)
    }
    .width('100%')
    .padding(24)
    .backgroundColor('rgba(10,28,65,0.75)')
    .borderRadius(24)
  }
}
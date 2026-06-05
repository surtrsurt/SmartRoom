// 空调控制面板
// 查拉图斯特拉如是说

@ComponentV2
export struct AirConditionPanel {
  // 空调状态
  @Param airPower: boolean = false
  @Param airTemp: number = 24
  @Param autoModeOn: boolean = false
  @Param powerfulModeOn: boolean = false
  // 回调
  @Param onTempChange: (temp: number) => void = () => {}
  @Param onPowerChange: (power: boolean) => void = () => {}
  @Param onAutoModeToggle: () => void = () => {}
  @Param onPowerfulModeToggle: () => void = () => {}

  build() {
    Column() {
      Text('空调')
        .fontSize(28)
        .fontColor('#F4D39A')

      // 空调图标
      Image(this.airPower ?
        $r('app.media.home_icon_airconditioner_select') :
        $r('app.media.home_icon_airconditioner_unselect'))
        .width(120)
        .height(70)
        .margin({ top: 12 })

      // 温度控制
      Row() {
        Image($r('app.media.home_btn_sub'))
          .width(70)
          .height(70)
          .onClick(() => {
            if (this.airTemp > 16) {
              this.onTempChange(this.airTemp - 1)
            }
          })

        Text(`${this.airTemp}℃`)
          .fontSize(52)
          .fontColor('#FFFFFF')
          .margin({ left: 30, right: 30 })

        Image($r('app.media.home_btn_add'))
          .width(70)
          .height(70)
          .onClick(() => {
            if (this.airTemp < 30) {
              this.onTempChange(this.airTemp + 1)
            }
          })
      }
      .margin({ top: 20 })

      // 电源开关
      Image($r('app.media.home_icon_close'))
        .width(72)
        .height(72)
        .margin({ top: 20 })
        .onClick(() => this.onPowerChange(!this.airPower))

      Text('开关')
        .fontSize(20)
        .fontColor('#F4D39A')

      // 模式按钮（自动模式/强劲模式）
      Row({ space: 12 }) {
        // 自动模式
        Column() {
          Image(this.autoModeOn ?
            $r('app.media.home_auto_mode_select') :
            $r('app.media.home_auto_mode_unselect'))
            .width(50)
            .height(50)

          Text('自动模式')
            .fontSize(20)
            .fontColor('#F4D39A')
            .margin({ top: 8 })
        }
        .width('47%')
        .height(80)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.autoModeOn ?
          'rgba(255,215,120,0.12)' : 'rgba(0,0,0,0)')
        .border({
          width: 1,
          color: this.autoModeOn ? '#DDB97A' : 'rgba(221,185,122,0.5)'
        })
        .borderRadius(16)
        .onClick(() => this.onAutoModeToggle())

        // 强劲模式
        Column() {
          Image(this.powerfulModeOn ?
            $r('app.media.home_powerful_mode_select') :
            $r('app.media.home_powerful_mode_unselect'))
            .width(50)
            .height(50)

          Text('强劲模式')
            .fontSize(20)
            .fontColor('#F4D39A')
            .margin({ top: 8 })
        }
        .width('47%')
        .height(80)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.powerfulModeOn ?
          'rgba(255,215,120,0.12)' : 'rgba(0,0,0,0)')
        .border({
          width: 1,
          color: this.powerfulModeOn ? '#DDB97A' : 'rgba(221,185,122,0.5)'
        })
        .borderRadius(16)
        .onClick(() => this.onPowerfulModeToggle())
      }
      .margin({ top: 24 })
    }
    .width('100%')
    .padding(24)
    .backgroundColor('rgba(10,28,65,0.75)')
    .borderRadius(24)
  }
}
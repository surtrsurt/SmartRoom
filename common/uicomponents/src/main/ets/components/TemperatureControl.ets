// 温度控制组件 - 加减按钮+数值
// 查拉图斯特拉如是说

@ComponentV2
export struct TemperatureControl {
  @Param temperature: number = 24
  @Param minTemp: number = 16
  @Param maxTemp: number = 30
  @Param onTempChange: (temp: number) => void = () => {}

  build() {
    Row() {
      Image($r('app.media.home_btn_sub'))
        .width(70)
        .height(70)
        .onClick(() => {
          if (this.temperature > this.minTemp) {
            this.onTempChange(this.temperature - 1)
          }
        })

      Text(`${this.temperature}℃`)
        .fontSize(52)
        .fontColor('#FFFFFF')
        .margin({ left: 30, right: 30 })

      Image($r('app.media.home_btn_add'))
        .width(70)
        .height(70)
        .onClick(() => {
          if (this.temperature < this.maxTemp) {
            this.onTempChange(this.temperature + 1)
          }
        })
    }
  }
}
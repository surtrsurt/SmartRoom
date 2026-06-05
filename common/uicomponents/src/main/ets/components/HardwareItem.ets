// 独立控制硬件项
// 查拉图斯特拉如是说

@ComponentV2
export struct HardwareItem {
  @Param icon: string = ''
  @Param name: string = ''
  @Param isOn: boolean = false
  @Param mainSwitchOn: boolean = false
  @Param onToggle: () => void = () => {}

  build() {
    Row() {
      Image($r(`app.media.${this.icon}`))
        .width(80)
        .height(80)

      Text(this.name)
        .fontSize(18)
        .fontColor(this.mainSwitchOn ? '#FFFFFF' : '#888888')
        .layoutWeight(1)
        .margin({ left: 12 })

      Image(this.mainSwitchOn && this.isOn ?
        $r('app.media.light_toggle_on') :
        $r('app.media.light_toggle_off'))
        .width(70)
        .height(70)
        .onClick(() => {
          if (this.mainSwitchOn) {
            this.onToggle()
          }
        })
        .stateStyles({
          normal: { .scale({ x: 1, y: 1 }) },
          pressed: { .scale({ x: 0.5, y: 0.5 }) }
        })
    }
    .width('100%')
    .height(64)
    .border({
      width: { bottom: 1 },
      color: 'rgba(255,255,255,0.1)'
    })
  }
}
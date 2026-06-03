// 服务页面
// 查拉图斯特拉如是说

@ComponentV2
@Entry
export struct ServicePage {

  @Local dndEnable: boolean = false
  @Local cleanEnable: boolean = false

  build() {
    Stack() {
      // 背景
      Image($r('app.media.service_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 深色蒙层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,8,25,0.45)')

      Scroll() {
        Column({ space: 22 }) {
          this.TitleBar()

          this.ServiceSwitchArea()

          this.SosCard()

          this.WeatherCard()

          this.LogoutCard()

          Blank()
            .height(120)
        }
        .padding({
          left: 24,
          right: 24,
          bottom: 24
        })
      }
      .scrollBar(BarState.On)
    }
    .width('100%')
    .height('100%')
    .clip(true)
  }

  @Builder
  private TitleBar() {
    Column() {
      Text('服务控制')
        .fontSize(38)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F5D8A3')

      Divider()
        .width(80)
        .height(2)
        .color('#D6B16A')
        .margin({ top: 8 })
    }
    .width('100%')
    .padding({ top: 60, bottom: 30 })
  }

  @Builder
  private ServiceSwitchArea() {
    Row({ space: 18 }) {
      this.ServiceCard(
        $r('app.media.service_icon_do_not_disturb'),
        '请勿打扰',
        this.dndEnable,
        (value: boolean) => {
          this.dndEnable = value
        }
      )

      this.ServiceCard(
        $r('app.media.service_icon_clean_room'),
        '清理房间',
        this.cleanEnable,
        (value: boolean) => {
          this.cleanEnable = value
        }
      )
    }
  }

  @Builder
  private ServiceCard(
    icon: Resource,
    title: string,
    checked: boolean,
    action: (value: boolean) => void
  ) {
    Column() {
      Image(icon)
        .width(90)
        .height(90)

      Text(title)
        .fontSize(28)
        .fontColor('#F4D39A')
        .margin({ top: 20 })

      Toggle({ type: ToggleType.Switch, isOn: checked })
        .onChange((value: boolean) => {
          action(value)
        })
        .margin({ top: 30 })
    }
    .width('48%')
    .height(300)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgba(10,28,65,0.88)')
    .borderRadius(24)
    .border({ width: 1, color: '#CDA15C' })
  }

  @Builder
  private SosCard() {
    Row() {
      Row() {
        Image($r('app.media.service_icon_sos'))
          .width(70)
          .height(70)
      }
      .width(120)
      .height(120)
      .backgroundColor('rgba(255,0,0,0.12)')
      .borderRadius(60)

      Column() {
        Text('SOS 紧急呼叫')
          .fontSize(34)
          .fontWeight(FontWeight.Bold)
          .fontColor('#F4D39A')

        Text('如遇紧急情况，请点击按钮联系我们')
          .fontSize(18)
          .fontColor('#D8D8D8')
          .margin({ top: 8 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 20 })

      Image($r('app.media.tabs_icon_service_unselect'))
        .width(28)
        .height(28)
    }
    .width('100%')
    .height(140)
    .padding(20)
    .backgroundColor('rgba(0,30,80,0.92)')
    .borderRadius(24)
    .border({
      width: 1,
      color: '#6EA8FF'
    })
    .shadow({
      radius: 25,
      color: 'rgba(80,120,255,0.25)'
    })
  }

  @Builder
  private WeatherCard() {
    Column() {
      Row() {
        Text('上海市 · 浦东新区')
          .fontSize(18)
          .fontColor('#E6E6E6')

        Blank()

        Text('空气质量 优')
          .fontSize(16)
          .fontColor('#8BE28B')
      }

      Row() {
        Column() {
          Text('26℃')
            .fontSize(72)
            .fontWeight(300)
            .fontColor('#FFFFFF')

          Text('多云')
            .fontSize(24)
            .fontColor('#FFFFFF')

          Text('体感28℃ | 湿度65%')
            .fontSize(16)
            .fontColor('#D8D8D8')
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        Column({ space: 10 }) {
          Text('今天   24℃ / 28℃')
            .fontSize(18)
            .fontColor('#FFFFFF')
          Text('明天   23℃ / 29℃')
            .fontSize(18)
            .fontColor('#FFFFFF')
          Text('后天   22℃ / 27℃')
            .fontSize(18)
            .fontColor('#FFFFFF')
        }
        .alignItems(HorizontalAlign.End)
      }
      .margin({ top: 25 })

      Text('温馨提示：空气良好，适宜出行')
        .fontSize(16)
        .fontColor('#9BE69B')
        .margin({ top: 20 })
    }
    .width('100%')
    .padding(24)
    .backgroundColor('rgba(15,35,80,0.88)')
    .borderRadius(24)
    .border({
      width: 1,
      color: '#5E7FC0'
    })
  }

  @Builder
  private LogoutCard() {
    Row() {
      Image($r('app.media.service_icon_log_out'))
        .width(48)
        .height(48)

      Text('退出登录')
        .fontSize(34)
        .fontWeight(FontWeight.Medium)
        .fontColor('#E8C27F')
        .margin({ left: 20 })

      Blank()

      Image($r('app.media.tabs_icon_service_unselect'))
        .width(30)
    }
    .width('100%')
    .height(120)
    .padding({
      left: 24,
      right: 24
    })
    .backgroundColor('rgba(10,28,65,0.88)')
    .borderRadius(24)
    .border({ width: 1, color: '#CDA15C' })
  }
}
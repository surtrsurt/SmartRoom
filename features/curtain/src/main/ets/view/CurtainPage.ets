// 窗帘页面
// 查拉图斯特拉如是说

enum CurtainState {
  OPEN,
  STOP,
  CLOSE
}

@ComponentV2
@Entry
export struct CurtainPage {
  @Local clothState: CurtainState = CurtainState.CLOSE
  @Local gauzeState: CurtainState = CurtainState.CLOSE

  build() {
    Stack() {
      // 背景图
      Image($r('app.media.curtain_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 蒙层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,10,30,0.45)')

      Scroll() {
        Column({ space: 24 }) {
          this.TitleBar()

          this.GlobalControlCard()

          this.CurtainCard('布帘', this.clothState, $r('app.media.curtain_icon_left_closed'), $r('app.media.curtain_icon_right_closed'), $r('app.media.curtain_icon_bg'))

          this.CurtainCard('窗纱', this.gauzeState, $r('app.media.curtain_icon_window_screening_left_part_closed'), $r('app.media.curtain_icon_window_screening_right_part_closed'), $r('app.media.curtain_icon_window_bg'))

          Blank()
            .height(120)
        }
        .padding(20)
      }
      .scrollBar(BarState.On)
    }
    .width('100%')
    .height('100%')
    .clip(true)
  }

  @Builder
  private TitleBar() {
    Row() {
      Text('')
        .width(34)
      Blank()
      Text('窗帘控制')
        .fontSize(34)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F4D39A')
      Blank()
      Text('')
        .width(34)
    }
    .width('100%')
    .padding({ top: 60, bottom: 20 })
  }

  @Builder
  private GlobalControlCard() {
    Row({ space: 18 }) {
      Column() {
        Image($r('app.media.curtain_icon_open_all'))
          .width(60)
          .height(60)
        Text('全部打开')
          .fontColor('#F4D39A')
          .fontSize(20)
          .margin({ top: 8 })
      }
      .width('48%')
      .height(120)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('rgba(10,28,65,0.88)')
      .borderRadius(20)
      .border({ width: 1, color: '#CDA15C' })

      Column() {
        Image($r('app.media.curtain_icon_close_all'))
          .width(60)
          .height(60)
        Text('全部关闭')
          .fontColor('#F4D39A')
          .fontSize(20)
          .margin({ top: 8 })
      }
      .width('48%')
      .height(120)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('rgba(10,28,65,0.88)')
      .borderRadius(20)
      .border({ width: 1, color: '#CDA15C' })
    }
  }

  @Builder
  private CurtainCard(title: string, state: CurtainState, leftImage: Resource, rightImage: Resource, bgImage: Resource) {
    Column() {
      Row() {
        Column() {
          Text(title)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F4D39A')
          Divider()
            .width(30)
            .height(3)
            .color('#F4D39A')
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
      }
      .width('100%')
      .margin({ bottom: 10 })

      Stack() {
        Image(bgImage)
          .width('100%')
          .height(160)
          .objectFit(ImageFit.Fill)
        Row() {
          Image(leftImage)
            .width('50%')
            .height(160)
            .objectFit(ImageFit.Cover)
          Image(rightImage)
            .width('50%')
            .height(160)
            .objectFit(ImageFit.Cover)
        }
      }
      .width('100%')

      Row() {
        this.ActionButton('打开', $r('app.media.curtain_icon_open'), state == CurtainState.OPEN, title)
        this.ActionButton('暂停', $r('app.media.curtain_icon_pause'), state == CurtainState.STOP, title)
        this.ActionButton('关闭', $r('app.media.curtain_icon_close'), state == CurtainState.CLOSE, title)
      }
      .margin({ top: 10 })
    }
    .padding(16)
    .backgroundColor('rgba(8,25,60,0.9)')
    .borderRadius(24)
    .border({ width: 1, color: '#CDA15C' })
  }

  @Builder
  private ActionButton(text: string, icon: Resource, active: boolean, cardType: string) {
    Row() {
      Image(icon)
        .width(20)
        .height(20)
      Text(text)
        .fontSize(18)
        .fontColor('#F4D39A')
        .margin({ left: 8 })
    }
    .width('33.33%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(active ? 'rgba(255,220,150,0.12)' : 'rgba(10,25,55,0.9)')
    .border({ width: 1, color: '#DDB97A' })
    .onClick(() => {
      if (text === '打开') {
        if (cardType === '布帘') {
          this.clothState = CurtainState.OPEN
        } else {
          this.gauzeState = CurtainState.OPEN
        }
      } else if (text === '暂停') {
        if (cardType === '布帘') {
          this.clothState = CurtainState.STOP
        } else {
          this.gauzeState = CurtainState.STOP
        }
      } else if (text === '关闭') {
        if (cardType === '布帘') {
          this.clothState = CurtainState.CLOSE
        } else {
          this.gauzeState = CurtainState.CLOSE
        }
      }
    })
  }
}
// 窗帘控制卡片
// 查拉图斯特拉如是说

@ComponentV2
export struct CurtainControlCard {
  @Param title: string = ''
  @Param isCloth: boolean = true
  @Param curtainPercent: number = 0
  @Param curtainState: string = 'closed'
  @Param selectedControl: string = ''
  @Param onOpen: () => void = () => {}
  @Param onPause: () => void = () => {}
  @Param onClose: () => void = () => {}

  build() {
    Column() {
      // 标题行
      Row() {
        Text(this.title)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#E2BD93')
      }
      .width('100%')
      .margin({ bottom: 10 })

      // 状态预览区
      this.CurtainPreview()

      // 进度条
      Row() {
        Text('0%')
          .fontSize(12)
          .fontColor('#FFFFFF')
        Slider({
          value: this.curtainPercent * 100,
          min: 0,
          max: 100,
          style: SliderStyle.OutSet
        })
          .enabled(false)
          .layoutWeight(1)
          .margin({ left: 8, right: 8 })
        Text('100%')
          .fontSize(12)
          .fontColor('#FFFFFF')
      }
      .width('100%')
      .padding({ top: 12 })

      // 控制按钮
      Row({ space: 10 }) {
        this.ControlButton('打开', 'curtain_icon_open', 'open')
        this.ControlButton('暂停', 'curtain_icon_pause', 'pause')
        this.ControlButton('关闭', 'curtain_icon_close', 'close')
      }
      .width('100%')
      .padding({ top: 12 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('rgba(17,27,58,0.9)')
    .borderRadius(24)
    .border({ width: 1, color: '#1F2C54' })
  }

  @Builder
  CurtainPreview() {
    Stack({ alignContent: Alignment.Center }) {
      // 背景图
      Image(this.isCloth ?
        $r('app.media.curtain_icon_bg') :
        $r('app.media.curtain_icon_window_bg'))
        .width('100%')
        .height(160)
        .objectFit(ImageFit.Cover)
        .visibility(this.curtainPercent >= 1.0 ? Visibility.Visible : Visibility.None)

      // 左右帘子
      if (this.curtainPercent < 1.0) {
        Stack() {
          // 左帘子
          Image(this.curtainPercent > 0.5 ?
            (this.isCloth ? $r('app.media.curtain_icon_left_open') : $r('app.media.curtain_icon_window_screening_left_part_open')) :
            (this.isCloth ? $r('app.media.curtain_icon_left_closed') : $r('app.media.curtain_icon_window_screening_left_part_closed')))
            .width('70%')
            .height(160)
            .objectFit(ImageFit.Cover)
            .position({ x: 0, y: 0 })
            .translate({ x: -this.curtainPercent * 60 })

          // 右帘子
          Image(this.curtainPercent > 0.5 ?
            (this.isCloth ? $r('app.media.curtain_icon_right_open') : $r('app.media.curtain_icon_window_screening_right_part_open')) :
            (this.isCloth ? $r('app.media.curtain_icon_right_closed') : $r('app.media.curtain_icon_window_screening_right_part_closed')))
            .width('70%')
            .height(160)
            .objectFit(ImageFit.Cover)
            .position({ x: '30%', y: 0 })
            .translate({ x: this.curtainPercent * 60 })
        }
        .width('100%')
        .height(160)
        .clip(true)
      }
    }
    .width('100%')
    .height(160)
    .borderRadius(12)
    .clip(true)
  }

  @Builder
  ControlButton(label: string, iconName: string, action: string) {
    Row() {
      Image($r(`app.media.${iconName}`))
        .width(40)
        .height(40)
      Text(label)
        .fontSize(16)
        .fontColor(this.getHighlighted(action) ? '#D7C189' : '#FFFFFF')
        .margin({ left: 8 })
    }
    .width('31%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .borderRadius(8)
    .backgroundColor(this.getHighlighted(action) ? 'rgba(215, 193, 137, 0.15)' : 'rgba(255, 255, 255, 0.08)')
    .border({ width: 1, color: this.getHighlighted(action) ? '#D7C189' : '#404F7A' })
    .onClick(() => this.getClickHandler(action)())
  }

  private getHighlighted(action: string): boolean {
    const type = this.isCloth ? 'cloth' : 'gauze'

    if (action === 'pause') {
      return this.curtainState === 'paused'
    }

    if (this.selectedControl !== type) {
      return false
    }

    if (action === 'open') {
      return this.curtainState === 'opening' || this.curtainState === 'opened'
    } else {
      return this.curtainState === 'closing' || this.curtainState === 'closed'
    }
  }

  private getClickHandler(action: string): () => void {
    if (action === 'open') {
      return this.onOpen
    } else if (action === 'pause') {
      return this.onPause
    } else {
      return this.onClose
    }
  }
}
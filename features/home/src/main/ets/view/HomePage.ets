// 首页页面
// 查拉图斯特拉如是说

import { HomeViewModel } from '../viewmodel/HomeViewModel.ets'

@ComponentV2
@Entry
export struct HomePage {
  @Local viewModel: HomeViewModel = new HomeViewModel()

  aboutToAppear(): void {
    this.viewModel.loadRoomState()
  }

  build() {
    Stack() {
      // 背景图片
      Image($r('app.media.home_background'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        // 标题
        Text('首页控制')
          .fontSize(34)
          .fontWeight(FontWeight.Bold)
          .fontColor('#F4D39A')
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 60, bottom: 20 })

        Scroll() {
          Column({ space: 22 }) {
            // 场景模式网格
            this.SceneGrid()

            // 空调卡片
            this.AirConditionCard()

            // 服务卡片
            this.ServiceCard()

            // 夜灯卡片
            this.NightLightCard()

            // 晚安模式卡片
            this.GoodNightCard()

            Blank()
              .height(40)
          }
          .padding(24)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .clip(true)
  }

  // 场景模式网格 - 2x2布局
  @Builder
  private SceneGrid() {
    Grid() {
      GridItem() {
        this.SceneItem('home_icon_bright', '明亮模式', 1)
      }

      GridItem() {
        this.SceneItem('home_icon_soft', '柔和模式', 2)
      }

      GridItem() {
        this.SceneItem('home_icon_read', '阅读模式', 3)
      }

      GridItem() {
        this.SceneItem('home_icon_warm', '温馨模式', 4)
      }
    }
    .columnsTemplate('1fr 1fr')
    .rowsGap(16)
    .columnsGap(16)
    .padding(24)
    .backgroundColor('rgba(10,28,65,0.75)')
    .borderRadius(24)
  }

  @Builder
  private SceneItem(iconName: string, title: string, sceneId: number) {
    Column() {
      Image(this.viewModel.lightSceneStore.lightScene === sceneId ?
        $r(`app.media.${iconName}_select`) : $r(`app.media.${iconName}_unselect`))
        .width(110)
        .height(110)

      Text(title)
        .fontSize(24)
        .fontColor('#F4D39A')
        .margin({ top: 12 })
    }
    .width('100%')
    .height(160)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.viewModel.lightSceneStore.lightScene === sceneId ?
      'rgba(255,215,120,0.15)' : 'rgba(0,0,0,0.2)')
    .borderRadius(20)
    .border({
      width: 1,
      color: this.viewModel.lightSceneStore.lightScene === sceneId ? '#DDB97A' : 'rgba(221,185,122,0.3)'
    })
    .onClick(() => {
      this.viewModel.setLightScene(sceneId)
    })
  }

  // 空调卡片
  @Builder
  private AirConditionCard() {
    Column() {
      Text('空调')
        .fontSize(28)
        .fontColor('#F4D39A')

      // 空调图标
      Image(this.viewModel.airPower ?
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
            if (this.viewModel.airTemp > 16) {
              this.viewModel.setAirTemp(this.viewModel.airTemp - 1)
            }
          })

        Text(`${this.viewModel.airTemp}℃`)
          .fontSize(52)
          .fontColor('#FFFFFF')
          .margin({ left: 30, right: 30 })

        Image($r('app.media.home_btn_add'))
          .width(70)
          .height(70)
          .onClick(() => {
            if (this.viewModel.airTemp < 30) {
              this.viewModel.setAirTemp(this.viewModel.airTemp + 1)
            }
          })
      }
      .margin({ top: 20 })

      // 电源开关
      Image($r('app.media.home_icon_close'))
        .width(72)
        .height(72)
        .margin({ top: 20 })
        .onClick(() => {
          this.viewModel.setAirPower(!this.viewModel.airPower)
        })

      Text('开关')
        .fontSize(20)
        .fontColor('#F4D39A')

      // 模式按钮
      Row() {
        this.ModeButton('home_auto_mode', '自动模式', 0)
        this.ModeButton('home_powerful_mode', '强劲模式', 1)
      }
      .margin({ top: 24 })
    }
    .width('100%')
    .padding(24)
    .backgroundColor('rgba(10,28,65,0.75)')
    .borderRadius(24)
  }

  @Builder
  private ModeButton(iconName: string, title: string, mode: number) {
    Column() {
      Image(this.viewModel.airMode === mode ?
        $r(`app.media.${iconName}_select`) : $r(`app.media.${iconName}_unselect`))
        .width(50)
        .height(50)

      Text(title)
        .fontSize(24)
        .fontColor('#F4D39A')
        .margin({ top: 8 })
    }
    .width('48%')
    .height(90)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.viewModel.airMode === mode ?
      'rgba(255,215,120,0.12)' : 'rgba(0,0,0,0)')
    .border({
      width: 1,
      color: this.viewModel.airMode === mode ? '#DDB97A' : 'rgba(221,185,122,0.5)'
    })
    .borderRadius(16)
    .onClick(() => {
      this.viewModel.setAirMode(mode)
    })
  }

  // 服务卡片
  @Builder
  private ServiceCard() {
    Row({ space: 16 }) {
      this.ShortcutCardUndiburb()
      this.ShortcutCardClear()
    }
  }

  @Builder
  private ShortcutCardUndiburb() {
    Column() {
      Image($r('app.media.home_icon_undisturb'))
        .width(90)
        .height(90)

      Text('请勿打扰')
        .fontSize(24)
        .fontColor(this.viewModel.disturbModeOn ? '#DDB97A' : '#F4D39A')
        .margin({ top: 12 })
    }
    .width('48%')
    .height(140)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.viewModel.disturbModeOn ? 'rgba(255,215,120,0.15)' : 'rgba(0,0,0,0.2)')
    .borderRadius(24)
    .border({ width: 1, color: this.viewModel.disturbModeOn ? '#DDB97A' : 'rgba(221,185,122,0.3)' })
    .onClick(() => this.viewModel.toggleDisturbMode())
  }

  @Builder
  private ShortcutCardClear() {
    Column() {
      Image($r('app.media.home_icon_clear'))
        .width(80)
        .height(80)

      Text('清理房间')
        .fontSize(24)
        .fontColor(this.viewModel.cleanRoomOn ? '#DDB97A' : '#F4D39A')
        .margin({ top: 12 })
    }
    .width('48%')
    .height(140)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.viewModel.cleanRoomOn ? 'rgba(255,215,120,0.15)' : 'rgba(0,0,0,0.2)')
    .borderRadius(24)
    .border({ width: 1, color: this.viewModel.cleanRoomOn ? '#DDB97A' : 'rgba(221,185,122,0.3)' })
    .onClick(() => this.viewModel.toggleCleanRoom())
  }

  // 夜灯卡片
  @Builder
  private NightLightCard() {
    Column() {
      Text('夜灯')
        .fontSize(26)
        .fontColor('#F4D39A')
        .width('100%')
        .textAlign(TextAlign.Start)

      Row() {
        // 左夜灯
        Column() {
          Image(this.viewModel.leftNightLightOn ?
            $r('app.media.home_icon_night_left_select') :
            $r('app.media.home_icon_night_left_unselect'))
            .width(100)
            .height(100)

          Text('左夜灯')
            .fontSize(18)
            .fontColor('#F4D39A')
            .margin({ top: 8 })
        }
        .layoutWeight(1)
        .height(120)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.viewModel.leftNightLightOn ?
          'rgba(255,215,120,0.12)' : 'rgba(0,0,0,0.2)')
        .borderRadius(16)
        .border({
          width: 1,
          color: this.viewModel.leftNightLightOn ? '#DDB97A' : 'rgba(221,185,122,0.3)'
        })
        .onClick(() => this.viewModel.toggleLeftNightLight())

        Divider()
          .vertical(true)
          .height(80)
          .color('rgba(221,185,122,0.3)')

        // 右夜灯
        Column() {
          Image(this.viewModel.rightNightLightOn ?
            $r('app.media.home_icon_night_right_select') :
            $r('app.media.home_icon_night_right_unselect'))
            .width(100)
            .height(100)

          Text('右夜灯')
            .fontSize(18)
            .fontColor('#F4D39A')
            .margin({ top: 8 })
        }
        .layoutWeight(1)
        .height(120)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.viewModel.rightNightLightOn ?
          'rgba(255,215,120,0.12)' : 'rgba(0,0,0,0.2)')
        .borderRadius(16)
        .border({
          width: 1,
          color: this.viewModel.rightNightLightOn ? '#DDB97A' : 'rgba(221,185,122,0.3)'
        })
        .onClick(() => this.viewModel.toggleRightNightLight())
      }
      .height(120)
    }
    .width('100%')
    .padding(24)
    .backgroundColor('rgba(10,28,65,0.75)')
    .borderRadius(24)
  }

  // 晚安模式卡片
  @Builder
  private GoodNightCard() {
    Row() {
      Image(this.viewModel.goodNightModeOn ?
        $r('app.media.home_good_night_mode_select') :
        $r('app.media.home_good_night_mode_unselect'))
        .width(80)
        .height(80)

      Text('晚安模式')
        .fontSize(30)
        .fontColor('#F4D39A')
        .margin({ left: 20 })
    }
    .width('100%')
    .height(100)
    .padding({ left: 24 })
    .justifyContent(FlexAlign.Start)
    .backgroundColor('rgba(10,28,65,0.75)')
    .borderRadius(24)
    .border({
      width: 1,
      color: this.viewModel.goodNightModeOn ? '#DDB97A' : 'rgba(221,185,122,0.5)'
    })
    .onClick(() => this.viewModel.toggleGoodNightMode())
  }
}

// 首页页面
//查拉图斯特拉如是说

import { hilog } from '@kit.PerformanceAnalysisKit'
import { window } from '@kit.ArkUI'
import { HomeViewModel } from '../viewmodel/HomeViewModel.ets'
import { AirConditionerCard } from 'features_air'
import { SceneModeCard } from '../components/SceneModeCard.ets'
import { NightLightCard } from '../components/NightLightCard.ets'
import { GoodNightModeCard } from '../components/GoodNightModeCard.ets'
import { ServiceStatusBar } from '../components/ServiceStatusBar.ets'

@ComponentV2
export struct HomePage {
  viewModel: HomeViewModel = new HomeViewModel()

  build() {
    Stack() {
      Image($r('app.media.home_background'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        this.WelcomeHeader()

        Scroll() {
          Column() {
            ServiceStatusBar({
              disturbMode: this.viewModel.disturbMode,
              cleanRoom: this.viewModel.cleanRoom,
              onDisturbToggle: () => this.viewModel.toggleDisturbMode(),
              onCleanRoomToggle: () => this.viewModel.toggleCleanRoom()
            })

            AirConditionerCard({
              airState: { power: this.viewModel.airPower, mode: this.viewModel.airMode, temp: this.viewModel.airTemp, speed: this.viewModel.airSpeed },
              onPowerChange: (power) => this.viewModel.setAirPower(power),
              onTempChange: (temp) => this.viewModel.setAirTemp(temp),
              onModeChange: (mode) => this.viewModel.setAirMode(mode)
            })

            SceneModeCard({
              currentScene: this.viewModel.lightScene,
              onSceneChange: (scene) => this.viewModel.setLightScene(scene)
            })

            NightLightCard({
              leftOn: this.viewModel.leftNightLightOn,
              rightOn: this.viewModel.rightNightLightOn,
              onLeftToggle: () => this.viewModel.toggleLeftNightLight(),
              onRightToggle: () => this.viewModel.toggleRightNightLight()
            })

            GoodNightModeCard({
              goodNightModeOn: this.viewModel.goodNightModeOn,
              onToggle: () => this.viewModel.toggleGoodNightMode()
            })
          }
          .padding({ left: 32, right: 32, bottom: 100 })
        }
        .layoutWeight(1)
        .scrollBar(BarState.On)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .clip(true)
  }

  @Builder
  WelcomeHeader() {
    Row() {
      Column() {
        Text(`房间 ${this.viewModel.roomNo}`)
          .fontSize(16)
          .fontColor('#FFFFFF')
        Text(`欢迎 ${this.viewModel.firstName}入住`)
          .fontSize(24)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ top: 40, left: 40, right: 24 })
  }

  aboutToAppear(): void {
    this.viewModel.loadRoomState()
  }

  onPageShow(): void {
    // 每次页面显示时确保沉浸模式
    try {
      window.getLastWindow(getContext(this)).then((win) => {
        win.setWindowLayoutFullScreen(true)
      })
    } catch (e) {
      hilog.info(0x0000, 'HomePage', 'set full screen failed')
    }
  }
}
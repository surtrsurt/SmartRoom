// 首页页面
// 查拉图斯特拉如是说

import { HomeViewModel } from '../viewmodel/HomeViewModel.ets'
import {
  TitleSection,
  SceneCard,
  AirConditionPanel,
  ServiceCardPanel,
  NightLightPanel
} from 'common_uicomponents'

@ComponentV2
export struct HomePage {
  @Local viewModel: HomeViewModel = new HomeViewModel()

  aboutToAppear(): void {
    this.viewModel.loadRoomState()
  }

  build() {
    Stack() {
      Image($r('app.media.home_background'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        TitleSection({ title: '首页控制' })

        Scroll() {
          Column({ space: 22 }) {
            this.SceneGrid()
            AirConditionPanel({
              airPower: this.viewModel.airPower,
              airTemp: this.viewModel.airTemp,
              autoModeOn: this.viewModel.autoModeOn,
              powerfulModeOn: this.viewModel.powerfulModeOn,
              onTempChange: (temp: number) => this.viewModel.setAirTemp(temp),
              onPowerChange: (power: boolean) => this.viewModel.setAirPower(power),
              onAutoModeToggle: () => this.viewModel.toggleAutoMode(),
              onPowerfulModeToggle: () => this.viewModel.togglePowerfulMode()
            })
            ServiceCardPanel({
              disturbSelected: this.viewModel.disturbModeOn,
              cleanRoomSelected: this.viewModel.cleanRoomOn,
              onDisturbToggle: () => this.viewModel.toggleDisturbMode(),
              onCleanRoomToggle: () => this.viewModel.toggleCleanRoom()
            })
            NightLightPanel({
              leftSelected: this.viewModel.leftNightLightOn,
              rightSelected: this.viewModel.rightNightLightOn,
              onLeftToggle: () => this.viewModel.toggleLeftNightLight(),
              onRightToggle: () => this.viewModel.toggleRightNightLight()
            })
            this.GoodNightCard()
            Blank().height(40)
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

  @Builder
  private SceneGrid() {
    Grid() {
      GridItem() { this.SceneItem('home_icon_bright', '明亮模式', 1) }
      GridItem() { this.SceneItem('home_icon_soft', '柔和模式', 2) }
      GridItem() { this.SceneItem('home_icon_read', '阅读模式', 3) }
      GridItem() { this.SceneItem('home_icon_warm', '温馨模式', 4) }
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
    SceneCard({
      selectIcon: $r(`app.media.${iconName}_select`),
      unselectIcon: $r(`app.media.${iconName}_unselect`),
      title: title,
      isSelected: this.viewModel.lightSceneStore.lightScene === sceneId,
      isEnabled: this.viewModel.lightSceneStore.mainSwitch,
      onClickHandler: () => this.viewModel.setLightScene(sceneId)
    })
  }

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
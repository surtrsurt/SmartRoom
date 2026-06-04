// 灯光页面
// 查拉图斯特拉如是说

import { LightViewModel } from '../viewmodel/LightViewModel.ets'
import { LightSceneStore } from 'common_datastore'
import { LightScene } from '../model/LightModel.ets'
import type { LightHardwareInfo } from '../model/LightModel.ets'

interface LightSceneItem {
  id: number
  name: string
  selectIcon: string
  unselectIcon: string
}

@ComponentV2
export struct LightPage {
  @Local viewModel: LightViewModel = new LightViewModel()

  private scenes: LightSceneItem[] = [
    { id: LightScene.BRIGHT, name: '明亮', selectIcon: 'light_icon_bright_mode_select', unselectIcon: 'light_icon_bright_mode_unselect' },
    { id: LightScene.SOFT, name: '柔和', selectIcon: 'light_icon_soft_mode_select', unselectIcon: 'light_icon_soft_mode_unselect' },
    { id: LightScene.READ, name: '阅读', selectIcon: 'light_icon_read_mode_select', unselectIcon: 'light_icon_read_mode_unselect' },
    { id: LightScene.WARM, name: '温馨', selectIcon: 'light_icon_warm_mode_select', unselectIcon: 'light_icon_warm_mode_unselect' },
    { id: LightScene.SLEEP, name: '入睡', selectIcon: 'light_icon_sleep_mode_select', unselectIcon: 'light_icon_sleep_mode_unselect' }
  ]

  private onSceneChange = (scene: number): void => {
    this.viewModel.applyHardwareStates(scene)
  }

  aboutToAppear(): void {
    LightSceneStore.getInstance().registerSceneChangeListener(this.onSceneChange)
    this.viewModel.applyHardwareStates(LightSceneStore.getInstance().lightScene)
  }

  aboutToDisappear(): void {
    LightSceneStore.getInstance().unregisterSceneChangeListener(this.onSceneChange)
  }

  build() {
    Stack() {
      Image($r('app.media.light_bg')).width('100%').height('100%').objectFit(ImageFit.Cover)
      Scroll() {
        Column({ space: 20 }) {
          this.TitleSection()
          this.MainSwitchCard()
          this.SceneModeCard()
          this.IndependentControlCard()
          Blank().height(120)
        }
        .padding(20)
      }
    }
    .width('100%').height('100%').clip(true)
  }

  @Builder
  TitleSection() {
    Column() {
      Text('灯光控制').fontSize(38).fontWeight(FontWeight.Bold).fontColor('#F5D8A3')
      Divider().width(80).height(2).color('#D6B16A').margin({ top: 8 })
    }
    .width('100%').padding({ top: 60, bottom: 30 })
  }

  @Builder
  MainSwitchCard() {
    Row() {
      Column() {
        Text('总开关').fontSize(24).fontColor('#F5D08A').fontWeight(FontWeight.Bold)
        Text('一键控制所有灯光').fontSize(16).fontColor('#FFFFFF').margin({ top: 8 })
      }
      .alignItems(HorizontalAlign.Start).layoutWeight(1)
      Image(this.viewModel.mainSwitch ? $r('app.media.light_btn_main_switch_select') : $r('app.media.light_btn_main_switch_unselect'))
        .width(150).height(150).onClick(() => this.viewModel.toggleMainSwitch())
    }
    .width('100%').height(140).padding(24).backgroundColor('#091B3B').borderRadius(28)
  }

  @Builder
  SceneModeCard() {
    Column() {
      Row() {
        Image($r('app.media.light_scene_mode')).width(48).height(48)
        Text('场景模式').fontSize(24).fontColor('#F5D08A').fontWeight(FontWeight.Bold).margin({ left: 12 })
      }
      .width('100%').margin({ bottom: 20 })
      Scroll() {
        Row({ space: 12 }) {
          ForEach(this.scenes, (scene: LightSceneItem) => {
            this.SceneCard(scene.selectIcon, scene.unselectIcon, scene.name + '模式', scene.id)
          })
        }
        .padding({ right: 20 })
      }
      .scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off).width('100%')
    }
    .width('100%').padding(20).backgroundColor('#091B3B').borderRadius(28)
  }

  @Builder
  SceneCard(selectIcon: string, unselectIcon: string, title: string, sceneId: number) {
    Column() {
      Image(this.viewModel.mainSwitch && this.viewModel.lightSceneStore.lightScene === sceneId ? $r(`app.media.${selectIcon}`) : $r(`app.media.${unselectIcon}`))
        .width(140).height(140)
      Text(title).fontColor('#F5D08A').fontSize(16).margin({ top: 8 })
    }
    .width(120).height(180).justifyContent(FlexAlign.Center).backgroundColor('#10264A').borderRadius(24)
    .onClick(() => this.viewModel.setLightScene(sceneId))
  }

  @Builder
  IndependentControlCard() {
    Column() {
      Row() {
        Image($r('app.media.light_independent_control')).width(56).height(56)
        Text('独立控制').fontSize(24).fontColor('#F5D08A').fontWeight(FontWeight.Bold).margin({ left: 8 })
      }
      .width('100%').margin({ bottom: 20 })
      Column() {
        ForEach(this.viewModel.hardwareList, (item: LightHardwareInfo) => {
          this.HardwareItem(item)
        })
      }
      .width('100%')
    }
    .width('100%').padding(20).backgroundColor('#091B3B').borderRadius(28)
  }

  @Builder
  HardwareItem(item: LightHardwareInfo) {
    Row() {
      Image($r(`app.media.${item.icon}`)).width(80).height(80)
      Text(item.name).fontSize(18).fontColor(this.viewModel.mainSwitch ? '#FFFFFF' : '#888888').layoutWeight(1).margin({ left: 12 })
      Image(this.viewModel.mainSwitch && item.on ? $r('app.media.light_toggle_on') : $r('app.media.light_toggle_off'))
        .width(70).height(70)
        .onClick(() => { if (this.viewModel.mainSwitch) this.viewModel.toggleHardware(item.id, !item.on) })
        .stateStyles({ normal: { .scale({ x: 1, y: 1 }) }, pressed: { .scale({ x: 0.5, y: 0.5 }) } })
    }
    .width('100%').height(64).border({ width: { bottom: 1 }, color: 'rgba(255,255,255,0.1)' })
  }
}
// 灯光页面
// 查拉图斯特拉如是说

import { LightViewModel } from '../viewmodel/LightViewModel.ets'
import { LightScene } from '../model/LightModel.ets'

interface LightSceneItem {
  id: number
  name: string
  selectIcon: string
  unselectIcon: string
}

interface HardwareItem {
  id: number
  name: string
  icon: string
  isOpen: boolean
}

@Entry
@ComponentV2
export struct LightPage {
  @Local viewModel: LightViewModel = new LightViewModel()
  @Local hardwareItems: HardwareItem[] = [
    { id: 1, name: '洗漱间', icon: 'light_icon_washroom', isOpen: true },
    { id: 2, name: '衣柜灯', icon: 'light_icon_wardrobe', isOpen: true },
    { id: 3, name: '落地灯', icon: 'light_icon_bar_lamp', isOpen: true },
    { id: 4, name: '吧台灯', icon: 'light_icon_desk', isOpen: true },
    { id: 5, name: '书桌灯', icon: 'light_icon_desk', isOpen: true },
    { id: 6, name: '左阅读灯', icon: 'light_icon_left_read', isOpen: true },
    { id: 7, name: '右阅读灯', icon: 'light_icon_right_read', isOpen: true },
    { id: 8, name: '风扇', icon: 'light_icon_exhaust_fan', isOpen: true },
    { id: 9, name: '廊灯', icon: 'light_icon_corrid_lights', isOpen: true }
  ]

  private scenes: LightSceneItem[] = [
    { id: LightScene.BRIGHT, name: '明亮', selectIcon: 'light_icon_bright_mode_select', unselectIcon: 'light_icon_bright_mode_unselect' },
    { id: LightScene.SOFT, name: '柔和', selectIcon: 'light_icon_soft_mode_select', unselectIcon: 'light_icon_soft_mode_unselect' },
    { id: LightScene.READ, name: '阅读', selectIcon: 'light_icon_read_mode_select', unselectIcon: 'light_icon_read_mode_unselect' },
    { id: LightScene.WARM, name: '温馨', selectIcon: 'light_icon_warm_mode_select', unselectIcon: 'light_icon_warm_mode_unselect' },
    { id: LightScene.SLEEP, name: '入睡', selectIcon: 'light_icon_sleep_mode_select', unselectIcon: 'light_icon_sleep_mode_unselect' }
  ]

  build() {
    Stack() {
      Image($r('app.media.light_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Scroll() {
        Column({ space: 20 }) {
          Text('灯光控制')
            .fontSize(34)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F5D08A')
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding({ top: 60 })

          // 总开关
          Row() {
            Column() {
              Text('总开关')
                .fontSize(24)
                .fontColor('#F5D08A')
                .fontWeight(FontWeight.Bold)
              Text('一键控制所有灯光')
                .fontSize(16)
                .fontColor('#FFFFFF')
                .margin({ top: 8 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Image(this.viewModel.mainSwitch ? $r('app.media.light_btn_main_switch_select') : $r('app.media.light_btn_main_switch_unselect'))
              .width(150)
              .height(150)
              .onClick(() => {
                this.viewModel.toggleMainSwitch()
              })
          }
          .width('100%')
          .height(140)
          .padding(24)
          .backgroundColor('#091B3B')
          .borderRadius(28)

          // 场景模式卡片
          Column() {
            Row() {
              Image($r('app.media.light_scene_mode'))
                .width(32)
                .height(32)
              Text('场景模式')
                .fontSize(24)
                .fontColor('#F5D08A')
                .fontWeight(FontWeight.Bold)
                .margin({ left: 8 })
            }
            .width('100%')
            .margin({ bottom: 20 })

            Scroll() {
              Row({ space: 12 }) {
                ForEach(this.scenes, (scene: LightSceneItem) => {
                  this.SceneCard(scene.selectIcon, scene.unselectIcon, scene.name + '模式', scene.id)
                })
              }
              .padding({ right: 20 })
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
            .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#091B3B')
          .borderRadius(28)

          // 独立控制卡片
          Column() {
            Row() {
              Image($r('app.media.light_independent_control'))
                .width(56)
                .height(56)
              Text('独立控制')
                .fontSize(24)
                .fontColor('#F5D08A')
                .fontWeight(FontWeight.Bold)
                .margin({ left: 8 })
            }
            .width('100%')
            .margin({ bottom: 20 })

            Column() {
              ForEach(this.hardwareItems, (item: HardwareItem) => {
                Row() {
                  Image($r(`app.media.${item.icon}`))
                    .width(80)
                    .height(80)

                  Text(item.name)
                    .fontSize(18)
                    .fontColor(this.viewModel.mainSwitch ? '#FFFFFF' : '#888888')
                    .layoutWeight(1)
                    .margin({ left: 12 })

                  Toggle({ type: ToggleType.Switch, isOn: this.viewModel.mainSwitch ? item.isOpen : false })
                    .selectedColor('#FACC15')
                    .enabled(this.viewModel.mainSwitch)
                    .onChange((isOn: boolean) => {
                      if (this.viewModel.mainSwitch) {
                        item.isOpen = isOn
                        this.viewModel.toggleHardware(item.id, isOn)
                      }
                    })
                }
                .width('100%')
                .height(64)
                .border({
                  width: { bottom: 1 },
                  color: 'rgba(255,255,255,0.1)'
                })
              })
            }
            .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#091B3B')
          .borderRadius(28)

          Blank()
            .height(120)
        }
        .padding(20)
      }
    }
    .width('100%')
    .height('100%')
    .clip(true)
  }

  @Builder
  SceneCard(selectIcon: string, unselectIcon: string, title: string, sceneId: number) {
    Column() {
      Image(this.viewModel.mainSwitch && this.viewModel.lightSceneStore.lightScene === sceneId ? $r(`app.media.${selectIcon}`) : $r(`app.media.${unselectIcon}`))
        .width(140)
        .height(140)

      Text(title)
        .fontColor('#F5D08A')
        .fontSize(16)
        .margin({ top: 8 })
    }
    .width(120)
    .height(180)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#10264A')
    .borderRadius(24)
    .onClick(() => {
      this.viewModel.setLightScene(sceneId)
    })
  }
}
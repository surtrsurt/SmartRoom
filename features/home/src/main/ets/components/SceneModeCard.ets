//场景模式卡片
//查拉图斯特拉如是说

import { ToastUtils } from 'common_uicomponents'

interface SceneModeItem {
  id: number
  name: string
  selectIcon: Resource
  unselectIcon: Resource
}

@ComponentV2
export struct SceneModeCard {
  @Param currentScene: number = 1
  @Param onSceneChange: (scene: number) => void = () => {}

  private scenes: SceneModeItem[] = [
    { id: 1, name: '明亮', selectIcon: $r('app.media.home_icon_bright_select'), unselectIcon: $r('app.media.home_icon_bright_unselect') },
    { id: 2, name: '柔和', selectIcon: $r('app.media.home_icon_soft_select'), unselectIcon: $r('app.media.home_icon_soft_unselect') },
    { id: 3, name: '阅读', selectIcon: $r('app.media.home_icon_read_select'), unselectIcon: $r('app.media.home_icon_read_unselect') },
    { id: 4, name: '温馨', selectIcon: $r('app.media.home_icon_warm_select'), unselectIcon: $r('app.media.home_icon_warm_unselect') }
  ]

  build() {
    Column() {
      Text('场景模式')
        .fontSize(18)
        .fontWeight(600)
        .fontColor('#FFFFFF')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 16 })

      Row() {
        ForEach(this.scenes, (scene: SceneModeItem) => {
          Column() {
            Image(this.currentScene === scene.id ? scene.selectIcon : scene.unselectIcon)
              .width(48)
              .height(48)
            Text(scene.name)
              .fontSize(14)
              .fontColor(this.currentScene === scene.id ? '#FACC15' : '#FFFFFF')
              .fontWeight(500)
              .margin({ top: 8 })
          }
          .flexGrow(1)
          .height(80)
          .borderRadius(24)
          .backgroundColor(this.currentScene === scene.id ? 'rgba(250,204,21,0.2)' : 'rgba(30,30,30,0.5)')
          .borderWidth(1)
          .borderColor(this.currentScene === scene.id ? '#FACC15' : 'rgba(250,204,21,0.4)')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.onSceneChange(scene.id)
            ToastUtils.show(`已切换到${scene.name}模式`)
          })
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(7,27,64,0.6)')
    .borderRadius(24)
    .border({ width: 1, color: 'rgba(255,255,255,0.2)' })
    .backdropBlur(15)
    .shadow({ radius: 10, color: 'rgba(0,0,0,0.2)', offsetX: 0, offsetY: 4 })
  }
}
// 窗帘页面
// 查拉图斯特拉如是说

import { CurtainViewModel } from '../viewmodel/CurtainViewModel.ets'
import { TitleSection, CurtainControlCard, CurtainTopControlCard } from 'common_uicomponents'

@ComponentV2
export struct CurtainPage {
  @Local viewModel: CurtainViewModel = new CurtainViewModel()

  aboutToAppear(): void {
    this.viewModel.initState()
  }

  build() {
    Stack() {
      Image($r('app.media.curtain_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,10,30,0.3)')

      Column() {
        TitleSection({ title: '窗帘控制' })

        Scroll() {
          Column({ space: 16 }) {
            CurtainTopControlCard({
              selectedControl: this.viewModel.selectedControl,
              onOpenAll: () => this.viewModel.openAll(),
              onCloseAll: () => this.viewModel.closeAll()
            })

            CurtainControlCard({
              title: '布帘',
              isCloth: true,
              curtainPercent: this.viewModel.clothPercent,
              curtainState: this.viewModel.clothState,
              selectedControl: this.viewModel.selectedControl,
              onOpen: () => this.viewModel.openCloth(),
              onPause: () => this.viewModel.pauseCloth(),
              onClose: () => this.viewModel.closeCloth()
            })

            CurtainControlCard({
              title: '窗纱',
              isCloth: false,
              curtainPercent: this.viewModel.gauzePercent,
              curtainState: this.viewModel.gauzeState,
              selectedControl: this.viewModel.selectedControl,
              onOpen: () => this.viewModel.openGauze(),
              onPause: () => this.viewModel.pauseGauze(),
              onClose: () => this.viewModel.closeGauze()
            })

            Blank().height(100)
          }
          .padding(16)
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
}
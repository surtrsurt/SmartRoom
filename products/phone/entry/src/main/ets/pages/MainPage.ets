// MainPage - 主页面（TabBar容器）
//查拉图斯特拉如是说

import { window } from '@kit.ArkUI'
import { TabBar } from '../components/TabBarComponent.ets'
import { HomePage } from 'features_home'
import { LightPage } from 'features_light'
import { CurtainPage } from 'features_curtain'
import { ServicePage } from 'features_service'

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0

  aboutToAppear(): void {
    try {
      window.getLastWindow(getContext(this)).then((win) => {
        win.setWindowLayoutFullScreen(true)
      })
    } catch (e) {
      console.info('MainPage set full screen failed')
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Tabs({ index: this.currentIndex }) {
        TabContent() {
          HomePage()
        }

        TabContent() {
          LightPage()
        }

        TabContent() {
          CurtainPage()
        }

        TabContent() {
          ServicePage()
        }
      }
      .barMode(BarMode.Scrollable)
      .barHeight(0)
      .onChange((index) => {
        this.currentIndex = index
      })
      .animationDuration(0)
      .height('100%')
      .layoutWeight(1)

      TabBar({
        currentIndex: this.currentIndex,
        onTabChange: (index) => {
          this.currentIndex = index
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}
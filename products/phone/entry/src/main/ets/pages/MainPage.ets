// MainPage - 主页面（TabBar容器 + NavHost）
//查拉图斯特拉如是说

import { window } from '@kit.ArkUI'
import { TabBar } from '../components/TabBarComponent.ets'
import { HomePage } from 'features_home'
import { LightPage } from 'features_light'
import { CurtainPage } from 'features_curtain'
import { ServicePage } from 'features_service'
import { LoginPage } from 'features_login'
import { TokenStore } from 'common_datastore'

@Entry
@ComponentV2
struct MainPage {
  @Local currentIndex: number = 0
  @Local showTabBar: boolean = true
  pathStack: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    // 检查登录状态
    const tokenStore = TokenStore.getInstance()
    const token = tokenStore.getToken()
    if (!token || tokenStore.isTokenExpired()) {
      // 未登录，清空栈并导航到登录页
      this.pathStack.clear()
      this.pathStack.pushPathByName('login', null)
      this.showTabBar = false
    }

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
      // Navigation包装Tabs
      Navigation(this.pathStack) {
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
            ServicePage({ pathStack: this.pathStack })
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
      }
      .hideTitleBar(true)
      .navDestination(this.pageMap)

      // TabBar 放在 Navigation 外部，Stack 的底部
      if (this.showTabBar) {
        TabBar({
          currentIndex: this.currentIndex,
          onTabChange: (index) => {
            this.currentIndex = index
          }
        })
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  pageMap(name: string, param: Object) {
    if (name === 'login') {
      NavDestination() {
        LoginPage({ pathStack: this.pathStack })
      }
      .hideTitleBar(true)
      .onShown(() => {
        this.showTabBar = false
      })
      .onHidden(() => {
        this.showTabBar = true
      })
    } else if (name === 'main') {
      // main就是Tab容器，登录成功后不需要额外处理
    }
  }
}
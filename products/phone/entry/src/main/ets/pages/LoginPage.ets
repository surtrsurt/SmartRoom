// 登录页面 - Entry页面
// 查拉图斯特拉如是说

import { LoginPage } from 'features_login'

@Entry
@Component
struct EntryLoginPage {
  build() {
    Column() {
      LoginPage()
    }
    .width('100%')
    .height('100%')
  }
}
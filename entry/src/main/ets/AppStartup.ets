import router from '@ohos.router'
import { PreferencesHelper } from './common/helper/PreferencesHelper'
import { common } from '@kit.AbilityKit'

export class AppStartup {
  async init(context: common.UIAbilityContext): Promise<void> {
    const prefHelper: PreferencesHelper = PreferencesHelper.getInstance()
    await prefHelper.init(context)

    // 从 preferences 读取 token
    const token: string = prefHelper.get('token', '') as string

    if (token) {
      // 如果有 token，跳转到 HomePage
      AppStorage.setOrCreate('token', token)
      router.pushUrl({ url: 'pages/HomePage' })
    } else {
      // 没有 token，停留在 LoginPage（默认页面）
      router.pushUrl({ url: 'pages/LoginPage' })
    }
  }
}
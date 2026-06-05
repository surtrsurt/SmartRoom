// 服务控制ViewModel - 请勿打扰、清理房间、SOS、退出登录
// 查拉图斯特拉如是说

import { promptAction } from '@kit.ArkUI'
import { ToastUtils } from 'common_uicomponents'
import { ServiceRepository } from '../repository/ServiceRepository.ets'
import { TokenStore, ServiceStore, type NavPathStackInterface } from 'common_datastore'
import type { ServiceControlRequest } from 'common_mock'

@ObservedV2
export class ServiceControlViewModel {
  @Trace disturbMode: boolean = false
  @Trace cleanRoom: boolean = false
  @Trace isLoading: boolean = false

  private repository: ServiceRepository = new ServiceRepository()
  private tokenStore: TokenStore = TokenStore.getInstance()
  private serviceStore: ServiceStore = ServiceStore.getInstance()
  pathStack: NavPathStackInterface | undefined = undefined

  aboutToAppear(): void {
    // 注册服务状态监听
    this.serviceStore.registerDisturbListener((enabled: boolean) => {
      this.disturbMode = enabled
    })
    this.serviceStore.registerCleanListener((enabled: boolean) => {
      this.cleanRoom = enabled
    })
    // 同步初始状态
    this.disturbMode = this.serviceStore.disturbMode
    this.cleanRoom = this.serviceStore.cleanRoom
  }

  toggleDisturbMode(): void {
    this.serviceStore.setDisturbMode(!this.serviceStore.disturbMode)
    ToastUtils.show(this.serviceStore.disturbMode ? '请勿打扰已开启' : '请勿打扰已关闭')
  }

  toggleCleanRoom(): void {
    this.serviceStore.setCleanRoom(!this.serviceStore.cleanRoom)
    ToastUtils.show(this.serviceStore.cleanRoom ? '清理房间已请求' : '清理房间已取消')
  }

  async requestSOS(): Promise<void> {
    try {
      await this.repository.requestSOS()
      ToastUtils.show('已通知工作人员')
    } catch (error) {
      ToastUtils.show('SOS请求失败')
    }
  }

  async logout(): Promise<void> {
    const action = await promptAction.showDialog({
      title: '退出登录',
      message: '确定要退出登录吗？',
      buttons: [
        { text: '取消', color: '#666666' },
        { text: '确定', color: '#E8C27F' }
      ]
    })

    if (action.index !== 1) {
      return
    }

    this.isLoading = true
    try {
      const req: ServiceControlRequest = { type: 'checkout' }
      await this.repository.controlService(req)
    } catch (error) {
      // 忽略API错误，直接退出
    } finally {
      this.isLoading = false
    }

    // 清理本地状态
    AppStorage.setOrCreate('token', '')
    AppStorage.setOrCreate('loginTime', 0)
    AppStorage.setOrCreate('isLogin', false)
    AppStorage.setOrCreate('firstName', '')
    this.tokenStore.clearToken()

    ToastUtils.show('已退出登录')

    if (this.pathStack) {
      this.pathStack.clear()
      this.pathStack.pushPathByName('login', null)
    }
  }
}
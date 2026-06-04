// 服务ViewModel
// 查拉图斯特拉如是说

import { ToastUtils } from 'common_uicomponents'
import { ServiceRepository } from '../repository/ServiceRepository.ets'
import { WeatherViewModel } from 'common_weather'
import type { ServiceControlRequest } from 'common_mock'
import { TokenStore, ServiceStore, type NavPathStackInterface } from 'common_datastore'

@ObservedV2
export class ServiceViewModel {
  @Trace disturbMode: boolean = false
  @Trace cleanRoom: boolean = false
  @Trace isSOSActive: boolean = false
  @Trace isLoading: boolean = false

  // 天气相关状态（委托给WeatherViewModel）
  weatherViewModel: WeatherViewModel = new WeatherViewModel()

  private repository: ServiceRepository = new ServiceRepository()
  private tokenStore: TokenStore = TokenStore.getInstance()
  private serviceStore: ServiceStore = ServiceStore.getInstance()
  // ViewModel不拥有pathStack，由页面传入
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
    this.isSOSActive = true
    ToastUtils.show('SOS呼叫中......')

    try {
      await this.repository.requestSOS()
      ToastUtils.show('已通知工作人员')
    } catch (error) {
      ToastUtils.show('SOS请求失败')
    } finally {
      this.isSOSActive = false
    }
  }

  async logout(): Promise<void> {
    this.isLoading = true

    try {
      const req: ServiceControlRequest = { type: 'checkout' }
      await this.repository.controlService(req)

      this.tokenStore.clearToken()

      ToastUtils.show('已退出登录')
      if (this.pathStack) {
        this.pathStack.clear()
        this.pathStack.pushPathByName('login', null)
      }
    } catch (error) {
      ToastUtils.show('退出失败')
    } finally {
      this.isLoading = false
    }
  }
}
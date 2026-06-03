// 服务ViewModel
// 查拉图斯特拉如是说

import { TokenStore } from 'common_datastore'
import { ToastUtils } from 'common_uicomponents'
import { ServiceRepository } from '../repository/ServiceRepository.ets'
import type { ServiceControlRequest } from 'common_mock'
import router from '@ohos.router'

export class ServiceViewModel {
  disturbMode: boolean = false
  cleanRoom: boolean = false
  isSOSActive: boolean = false
  isLoading: boolean = false

  private repository = new ServiceRepository()
  private tokenStore = TokenStore.getInstance()

  async toggleDisturbMode(): Promise<void> {
    this.disturbMode = !this.disturbMode

    const req: ServiceControlRequest = { type: 'disturb' }
    await this.repository.controlService(req)

    ToastUtils.show(this.disturbMode ? '请勿打扰已开启' : '请勿打扰已关闭')
  }

  async toggleCleanRoom(): Promise<void> {
    this.cleanRoom = !this.cleanRoom

    const req: ServiceControlRequest = { type: 'clean' }
    await this.repository.controlService(req)

    ToastUtils.show(this.cleanRoom ? '清理房间已请求' : '清理房间已取消')
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
      router.replaceUrl({ url: 'pages/LoginPage' })
    } catch (error) {
      ToastUtils.show('退出失败')
    } finally {
      this.isLoading = false
    }
  }
}
// 灯光ViewModel
// 查拉图斯特拉如是说

import { TokenStore } from 'common_datastore'
import { ToastUtils } from 'common_uicomponents'
import { LightRepository } from '../repository/LightRepository.ets'
import type { LightHardwareInfo, LightControlRequest } from 'common_mock'
import { LightScene } from '../model/LightModel.ets'

export class LightViewModel {
  mainSwitch: boolean = false
  currentScene: number = 1
  hardwareList: LightHardwareInfo[] = []
  isLoading: boolean = false

  private repository = new LightRepository()
  private tokenStore = TokenStore.getInstance()

  async setLightScene(scene: LightScene): Promise<void> {
    this.currentScene = scene

    const token = this.tokenStore.getToken()
    const req: LightControlRequest = { scene: scene }

    try {
      await this.repository.setLightMode(token, req)
      ToastUtils.show('场景切换成功')
    } catch (error) {
      ToastUtils.show('设置失败')
    }
  }

  async toggleHardware(hardwareId: number, on: boolean): Promise<void> {
    const hardware: LightHardwareInfo | undefined = this.hardwareList.find((h: LightHardwareInfo) => h.id === hardwareId)
    if (hardware) {
      hardware.on = on
    }

    const token = this.tokenStore.getToken()
    const req: LightControlRequest = { hardwareId: hardwareId, on: on }

    try {
      await this.repository.controlHardware(token, req)
    } catch (error) {
      if (hardware) {
        hardware.on = !on
      }
      ToastUtils.show('设置失败')
    }
  }

  async toggleMainSwitch(): Promise<void> {
    this.mainSwitch = !this.mainSwitch

    if (!this.mainSwitch) {
      // 关灯时场景也归零，全部按钮不亮
      this.currentScene = LightScene.NONE
    }

    const token = this.tokenStore.getToken()
    const req: LightControlRequest = { on: this.mainSwitch }

    try {
      await this.repository.setLightMode(token, req)
      ToastUtils.show(this.mainSwitch ? '灯光已开启' : '灯光已关闭')
    } catch (error) {
      this.mainSwitch = !this.mainSwitch
      ToastUtils.show('设置失败')
    }
  }

  setHardwareList(list: LightHardwareInfo[]): void {
    this.hardwareList = list
  }
}
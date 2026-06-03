// 灯光ViewModel
// 查拉图斯特拉如是说

import { hilog } from '@kit.PerformanceAnalysisKit'
import { TokenStore } from 'common_datastore'
import { LightSceneStore } from 'common_datastore'
import { ToastUtils } from 'common_uicomponents'
import { LightRepository } from '../repository/LightRepository.ets'
import type { LightHardwareInfo, LightControlRequest } from 'common_mock'
import { LightScene } from '../model/LightModel.ets'

@ObservedV2
export class LightViewModel {
  @Trace hardwareList: LightHardwareInfo[] = []
  @Trace isLoading: boolean = false

  // 共享灯光场景Store
  lightSceneStore: LightSceneStore = LightSceneStore.getInstance()

  // mainSwitch始终从Store读取，不自己保存
  get mainSwitch(): boolean {
    return this.lightSceneStore.mainSwitch
  }

  private repository = new LightRepository()
  private tokenStore = TokenStore.getInstance()

  async setLightScene(scene: LightScene): Promise<void> {
    // 总开关关闭时不允许切换场景
    if (!this.lightSceneStore.mainSwitch) {
      ToastUtils.show('请先开启灯光总开关')
      return
    }
    // 通过共享Store设置场景
    this.lightSceneStore.setLightScene(scene)

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
    const newState = !this.lightSceneStore.mainSwitch
    // 同步到共享Store
    this.lightSceneStore.setMainSwitch(newState)

    if (!newState) {
      // 关灯时场景归零，关闭所有独立控制
      this.lightSceneStore.setLightScene(LightScene.NONE)
      // 关闭所有硬件（保留状态以便恢复）
      this.closeAllHardware()
    } else {
      // 开灯时恢复所有独立控制（不包括夜灯，夜灯是首页单独控制的）
      this.restoreAllHardware()
    }

    const token = this.tokenStore.getToken()
    const req: LightControlRequest = { on: newState }

    try {
      await this.repository.setLightMode(token, req)
      ToastUtils.show(newState ? '灯光已开启' : '灯光已关闭')
    } catch (error) {
      this.lightSceneStore.setMainSwitch(!newState)
      ToastUtils.show('设置失败')
    }
  }

  private closeAllHardware(): void {
    // 关闭所有硬件（除了夜灯，夜灯是首页单独控制的）
    this.hardwareList.forEach((h: LightHardwareInfo) => {
      h.on = false
    })
  }

  private restoreAllHardware(): void {
    // 恢复所有硬件到开启状态
    this.hardwareList.forEach((h: LightHardwareInfo) => {
      h.on = true
    })
  }

  setHardwareList(list: LightHardwareInfo[]): void {
    this.hardwareList = list
  }
}
// 灯光ViewModel
// 查拉图斯特拉如是说

import { hilog } from '@kit.PerformanceAnalysisKit'
import { TokenStore } from 'common_datastore'
import { LightSceneStore } from 'common_datastore'
import { ToastUtils } from 'common_uicomponents'
import { LightRepository } from '../repository/LightRepository.ets'
import type { LightControlRequest } from 'common_mock'
import { LightScene, SCENE_HARDWARE_IDS, SCENE_HARDWARE_STATES, HARDWARE_ID_MAP, LightHardwareInfo } from '../model/LightModel.ets'

// 硬件图标映射
const HARDWARE_ICON_MAP: Record<string, string> = {
  '洗漱间': 'light_icon_washroom',
  '衣柜灯': 'light_icon_wardrobe',
  '落地灯': 'light_icon_bar_lamp',
  '吧台灯': 'light_icon_desk',
  '书桌灯': 'light_icon_desk',
  '左阅读灯': 'light_icon_left_read',
  '右阅读灯': 'light_icon_right_read',
  '排风扇': 'light_icon_exhaust_fan',
  '廊灯': 'light_icon_corrid_lights'
}

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

  private repository: LightRepository = new LightRepository()
  private tokenStore: TokenStore = TokenStore.getInstance()

  constructor() {
    // 初始化硬件列表（包含图标信息）
    this.initHardwareList()
  }

  // 初始化硬件列表
  private initHardwareList(): void {
    const entries = Object.entries(HARDWARE_ID_MAP)
    this.hardwareList = entries.map((entry) => {
      const name = entry[0]
      const id = entry[1]
      return new LightHardwareInfo(id, name, HARDWARE_ICON_MAP[name] || 'light_icon_desk', true)
    })
  }

  async setLightScene(scene: LightScene): Promise<void> {
    // 总开关关闭时不允许切换场景
    if (!this.lightSceneStore.mainSwitch) {
      ToastUtils.show('请先开启灯光总开关')
      return
    }
    // 通过共享Store设置场景
    this.lightSceneStore.setLightScene(scene)

    // 应用场景对应的硬件状态
    this.applyHardwareStates(scene)

    const token = this.tokenStore.getToken()
    // 根据接口文档，使用hardwareId而非scene
    const hardwareId = SCENE_HARDWARE_IDS[scene]
    const req: LightControlRequest = { hardwareId: hardwareId }

    try {
      await this.repository.setLightMode(token, req)
      ToastUtils.show('场景切换成功')
    } catch (error) {
      ToastUtils.show('设置失败')
    }
  }

  // 根据场景应用硬件状态
  applyHardwareStates(scene: LightScene): void {
    const stateMap = SCENE_HARDWARE_STATES[scene]
    if (!stateMap) return

    // 遍历hardwareList，根据场景状态设置每个硬件
    // 使用新对象替换以确保UI能检测到变化
    this.hardwareList = this.hardwareList.map((h: LightHardwareInfo) => {
      // 通过hardwareId找到对应的名称
      const entries = Object.entries(HARDWARE_ID_MAP)
      for (let i = 0; i < entries.length; i++) {
        const name = entries[i][0]
        const id = entries[i][1]
        if (id === h.id) {
          if (stateMap[name] !== undefined) {
            // 返回新对象以触发UI更新
            return new LightHardwareInfo(h.id, h.name, h.icon, stateMap[name])
          }
          break
        }
      }
      return h
    })
  }

  async toggleHardware(hardwareId: number, on: boolean): Promise<void> {
    // 总开关关闭时不允许操作
    if (!this.lightSceneStore.mainSwitch) {
      ToastUtils.show('请先开启灯光总开关')
      return
    }

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
    // 同步到共享Store（setMainSwitch会处理场景重置和晚安模式关闭）
    this.lightSceneStore.setMainSwitch(newState)

    if (newState) {
      // 开灯时恢复之前的场景（排除总关和入睡模式）
      const currentScene = this.lightSceneStore.lightScene
      if (currentScene === 0 || currentScene === LightScene.SLEEP) {
        // 如果之前是关闭状态，恢复到明亮模式
        this.lightSceneStore.setLightScene(LightScene.BRIGHT)
        this.applyHardwareStates(LightScene.BRIGHT)
      } else {
        // 恢复之前选择的场景
        this.applyHardwareStates(currentScene)
      }
    } else {
      // 关灯时应用入睡模式（全部关闭）
      this.applyHardwareStates(LightScene.SLEEP)
    }

    const token = this.tokenStore.getToken()
    // 根据接口文档，使用hardwareId: 103004(总关模式) 或 103001(明亮模式/开灯)
    const hardwareId = newState ? SCENE_HARDWARE_IDS[LightScene.BRIGHT] : SCENE_HARDWARE_IDS[LightScene.SLEEP]
    const req: LightControlRequest = { hardwareId: hardwareId }

    try {
      await this.repository.setLightMode(token, req)
      ToastUtils.show(newState ? '灯光已开启' : '灯光已关闭')
    } catch (error) {
      this.lightSceneStore.setMainSwitch(!newState)
      ToastUtils.show('设置失败')
    }
  }

  setHardwareList(list: LightHardwareInfo[]): void {
    this.hardwareList = list
  }
}
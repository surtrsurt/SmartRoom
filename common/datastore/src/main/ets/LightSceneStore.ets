// 灯光场景状态共享存储
// 查拉图斯特拉如是说

import { hilog } from '@kit.PerformanceAnalysisKit'
import { RoomStore } from './RoomStore.ets'

// 晚安模式回调类型
export type GoodNightCallback = (enabled: boolean) => void

@ObservedV2
export class LightSceneStore {
  @Trace lightScene: number = 1
  @Trace mainSwitch: boolean = true  // 默认开启

  private static instance: LightSceneStore
  private roomStore: RoomStore = RoomStore.getInstance()
  // 晚安模式回调
  private goodNightCallback: GoodNightCallback | null = null

  private constructor() {}

  static getInstance(): LightSceneStore {
    if (!LightSceneStore.instance) {
      LightSceneStore.instance = new LightSceneStore()
    }
    return LightSceneStore.instance
  }

  initFromRoomStore(): void {
    const savedLight = this.roomStore.getLightState()
    if (savedLight) {
      this.lightScene = savedLight.scene
      hilog.info(0x0000, 'LightSceneStore', 'initFromRoomStore: scene=%{public}d', this.lightScene)
    }
  }

  // 注册晚安模式回调（首页注册）
  registerGoodNightCallback(callback: GoodNightCallback): void {
    this.goodNightCallback = callback
  }

  setLightScene(scene: number): void {
    this.lightScene = scene
    // 同步到RoomStore持久化
    const currentLight = this.roomStore.getLightState()
    if (currentLight) {
      this.roomStore.setLightState({ mainSwitch: currentLight.mainSwitch, scene: scene, hardwareList: currentLight.hardwareList })
    }
    hilog.info(0x0000, 'LightSceneStore', 'setLightScene: %{public}d', scene)
    // 如果切换到入睡模式(5)，触发晚安模式
    if (scene === 5 && this.goodNightCallback) {
      this.goodNightCallback(true)
    }
  }

  setMainSwitch(on: boolean): void {
    this.mainSwitch = on
    // 同步到RoomStore持久化
    const currentLight = this.roomStore.getLightState()
    if (currentLight) {
      this.roomStore.setLightState({ mainSwitch: on, scene: this.lightScene, hardwareList: currentLight.hardwareList })
    }
    hilog.info(0x0000, 'LightSceneStore', 'setMainSwitch: %{public}d', on ? 1 : 0)
  }
}

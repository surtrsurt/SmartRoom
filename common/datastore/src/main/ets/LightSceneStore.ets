// 灯光场景状态共享存储
// 查拉图斯特拉如是说

import { hilog } from '@kit.PerformanceAnalysisKit'
import { RoomStore } from './RoomStore.ets'

// 晚安模式回调类型
export type GoodNightCallback = (enabled: boolean) => void

// 场景切换监听器类型
export type SceneChangeListener = (scene: number) => void

@ObservedV2
export class LightSceneStore {
  @Trace lightScene: number = 1
  @Trace mainSwitch: boolean = true  // 默认开启

  private static instance: LightSceneStore
  private roomStore: RoomStore = RoomStore.getInstance()
  // 晚安模式回调
  private goodNightCallback: GoodNightCallback | null = null
  // 场景切换监听器列表
  private sceneChangeListeners: SceneChangeListener[] = []
  // 防止在setMainSwitch中触发晚安回调的标志
  private suppressGoodNightCallback: boolean = false

  private constructor() {}

  static getInstance(): LightSceneStore {
    if (!LightSceneStore.instance) {
      LightSceneStore.instance = new LightSceneStore()
    }
    return LightSceneStore.instance
  }

  // 注册场景切换监听器
  registerSceneChangeListener(listener: SceneChangeListener): void {
    if (!this.sceneChangeListeners.includes(listener)) {
      this.sceneChangeListeners.push(listener)
    }
  }

  // 注销场景切换监听器
  unregisterSceneChangeListener(listener: SceneChangeListener): void {
    const index = this.sceneChangeListeners.indexOf(listener)
    if (index > -1) {
      this.sceneChangeListeners.splice(index, 1)
    }
  }

  // 通知所有监听器
  private notifySceneChange(scene: number): void {
    this.sceneChangeListeners.forEach((listener) => {
      listener(scene)
    })
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
    // 通知所有监听器（灯光页面会更新独立控制状态）
    this.notifySceneChange(scene)
    // 如果切换到入睡模式(5)，触发晚安模式（除非被setMainSwitch抑制）
    if (scene === 5 && this.goodNightCallback && !this.suppressGoodNightCallback) {
      this.goodNightCallback(true)
    }
  }

  setMainSwitch(on: boolean): void {
    this.mainSwitch = on
    // 关闭总开关时，重置场景到总关模式，避免与晚安模式冲突
    if (!on) {
      this.suppressGoodNightCallback = true  // 防止setLightScene触发晚安回调
      this.lightScene = 0  // 总关模式
      this.suppressGoodNightCallback = false
      // 直接调用关闭晚安模式回调
      if (this.goodNightCallback) {
        this.goodNightCallback(false)
      }
    }
    // 同步到RoomStore持久化
    const currentLight = this.roomStore.getLightState()
    if (currentLight) {
      this.roomStore.setLightState({ mainSwitch: on, scene: this.lightScene, hardwareList: currentLight.hardwareList })
    }
    hilog.info(0x0000, 'LightSceneStore', 'setMainSwitch: %{public}d', on ? 1 : 0)
  }
}

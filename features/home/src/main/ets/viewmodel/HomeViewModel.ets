// 首页ViewModel
// 查拉图斯特拉如是说

import { hilog } from '@kit.PerformanceAnalysisKit'
import { TokenStore } from 'common_datastore'
import { RoomStore } from 'common_datastore'
import { LightSceneStore } from 'common_datastore'
import { ServiceStore } from 'common_datastore'
import { ToastUtils } from 'common_uicomponents'
import { HomeRepository } from '../repository/HomeRepository.ets'
import { AirRepository } from 'features_air'
import type { RoomState } from '../model/HomeModel.ets'
import type { AirState } from 'common_datastore'

@ObservedV2
export class HomeViewModel {
  @Trace roomNo: string = ''
  @Trace firstName: string = ''
  @Trace roomState: RoomState | null = null
  @Trace isLoading: boolean = false
  @Trace leftNightLightOn: boolean = false
  @Trace rightNightLightOn: boolean = false
  @Trace isGoodNightExecuting: boolean = false
  // 直接追踪空调状态，解决UI更新问题
  @Trace airPower: boolean = false
  @Trace autoModeOn: boolean = false   // 自动模式（送风）
  @Trace powerfulModeOn: boolean = false  // 强劲模式（制冷）
  @Trace airTemp: number = 24
  @Trace airSpeed: number = 0  // 默认自动
  @Trace goodNightModeOn: boolean = false
  // 服务状态（选中效果需要@Trace）
  @Trace disturbModeOn: boolean = false
  @Trace cleanRoomOn: boolean = false
  // 保存关闭晚安模式前灯光场景
  private previousLightScene: number = 1

  // 共享灯光场景Store
  lightSceneStore: LightSceneStore = LightSceneStore.getInstance()
  // 共享服务状态Store
  serviceStore: ServiceStore = ServiceStore.getInstance()

  private repository: HomeRepository = new HomeRepository()
  private airRepository: AirRepository = new AirRepository()
  private tokenStore: TokenStore = TokenStore.getInstance()
  private roomStore: RoomStore = RoomStore.getInstance()

  async loadRoomState(): Promise<void> {
    const token = this.tokenStore.getToken()
    const roomNo = this.tokenStore.getRoomNo()

    hilog.info(0x0000, 'HomeViewModel', 'loadRoomState: token=%{public}s, roomNo=%{public}s', token, roomNo)

    if (!roomNo) {
      ToastUtils.show('房间号无效')
      return
    }

    // 注册晚安模式回调
    this.lightSceneStore.registerGoodNightCallback((enabled: boolean) => {
      this.goodNightModeOn = enabled
    })

    // 注册服务状态监听（请勿打扰/清理房间双向同步）
    this.serviceStore.registerDisturbListener((enabled: boolean) => {
      this.disturbModeOn = enabled
    })
    this.serviceStore.registerCleanListener((enabled: boolean) => {
      this.cleanRoomOn = enabled
    })

    // 同步初始服务状态
    this.disturbModeOn = this.serviceStore.disturbMode
    this.cleanRoomOn = this.serviceStore.cleanRoom

    this.isLoading = true

    try {
      const state = await this.repository.getState(token, roomNo)
      hilog.info(0x0000, 'HomeViewModel', 'getState result: roomNo=%{public}s, firstName=%{public}s', state.roomNo, state.firstName)
      this.roomNo = state.roomNo
      this.firstName = state.firstName
      this.roomState = state
      // 同步追踪的空调状态（从持久化存储恢复数据）
      const savedAir: AirState | null = this.roomStore.getAirState()
      if (state.air) {
        this.airPower = savedAir?.power ?? state.air.power
        this.airTemp = savedAir?.temp ?? state.air.temp
        this.airSpeed = savedAir?.speed ?? state.air.speed
        // 根据保存的状态恢复自动/强劲模式
        const savedMode = savedAir?.mode ?? state.air.mode
        this.autoModeOn = savedMode === 0  // 自动模式=送风
        this.powerfulModeOn = savedMode === 1  // 强劲模式=制冷
      }
      // 同步追踪的灯光场景
      if (state.lights) {
        this.lightSceneStore.setLightScene(state.lights.scene)
      }
    } catch (error) {
      hilog.error(0x0000, 'HomeViewModel', 'getState error: %{public}s', JSON.stringify(error))
      ToastUtils.show('获取房间状态失败')
    } finally {
      this.isLoading = false
    }
  }

  get lightState() {
    return this.roomState?.lights ?? null
  }

  get airState() {
    return this.roomState?.air ?? null
  }

  get disturbMode(): boolean {
    return this.disturbModeOn
  }

  get cleanRoom(): boolean {
    return this.cleanRoomOn
  }

  // 计算当前模式值（用于持久化和API）
  private getCurrentMode(): number {
    if (this.autoModeOn) return 0   // 自动模式=送风
    if (this.powerfulModeOn) return 1  // 强劲模式=制冷
    return -1  // 无模式
  }

  // 同步空调状态到持久化和roomState
  private syncAirState(): void {
    const mode = this.getCurrentMode()
    this.roomStore.setAirState({ power: this.airPower, mode: mode, temp: this.airTemp, speed: this.airSpeed })
    if (this.roomState && this.roomState.air) {
      const old = this.roomState.air
      this.roomState.air = { power: this.airPower, mode: mode, speed: old.speed, temp: old.temp }
    }
  }

  async setAirTemp(temp: number): Promise<void> {
    this.airTemp = temp
    this.syncAirState()
    // 空调开启时同步调用API
    if (this.airPower) {
      try {
        const token = this.tokenStore.getToken()
        await this.airRepository.clickAirBtn(token, { cmd: 'temp', value: temp })
      } catch (e) {
        hilog.error(0x0000, 'HomeViewModel', 'setAirTemp API error: %{public}s', JSON.stringify(e))
      }
    }
  }

  // 切换自动模式（送风）
  toggleAutoMode(): void {
    if (!this.airPower) {
      ToastUtils.show('请先开启空调')
      return
    }
    if (this.autoModeOn) {
      // 关闭自动模式
      this.autoModeOn = false
    } else {
      // 开启自动模式，同时关闭强劲模式
      this.autoModeOn = true
      this.powerfulModeOn = false
      // 调用API：送风模式
      this.airRepository.clickAirBtn(this.tokenStore.getToken(), { cmd: 'mode', value: 3 })
    }
    this.syncAirState()
  }

  // 切换强劲模式（制冷+21度）
  togglePowerfulMode(): void {
    if (!this.airPower) {
      ToastUtils.show('请先开启空调')
      return
    }
    if (this.powerfulModeOn) {
      // 关闭强劲模式
      this.powerfulModeOn = false
    } else {
      // 开启强劲模式，同时关闭自动模式
      this.powerfulModeOn = true
      this.autoModeOn = false
      // 调用API：制冷模式 + 21度
      this.airRepository.clickAirBtn(this.tokenStore.getToken(), { cmd: 'mode', value: 1 })
      this.airRepository.clickAirBtn(this.tokenStore.getToken(), { cmd: 'temp', value: 21 })
      this.airTemp = 21
    }
    this.syncAirState()
  }

  async setAirPower(power: boolean): Promise<void> {
    this.airPower = power
    if (!power) {
      // 关闭空调时，同时关闭两个模式
      this.autoModeOn = false
      this.powerfulModeOn = false
      ToastUtils.show('空调已关闭')
    }
    this.syncAirState()
    // 调用API同步空调状态
    try {
      const token = this.tokenStore.getToken()
      await this.airRepository.clickAirBtn(token, { cmd: 'power', value: power ? 1 : 0 })
      // 开启时同步当前温度
      if (power) {
        await this.airRepository.clickAirBtn(token, { cmd: 'temp', value: this.airTemp })
      }
    } catch (e) {
      hilog.error(0x0000, 'HomeViewModel', 'setAirPower API error: %{public}s', JSON.stringify(e))
    }
  }

  setLightScene(scene: number): void {
    // 总开关关闭时不允许切换场景
    if (!this.lightSceneStore.mainSwitch) {
      ToastUtils.show('请先开启灯光总开关')
      return
    }
    // 如果晚安模式开启中，先关闭晚安模式再切换
    if (this.goodNightModeOn) {
      this.goodNightModeOn = false
    }
    // 通过共享Store设置场景
    this.lightSceneStore.setLightScene(scene)
  }

  toggleDisturbMode(): void {
    this.serviceStore.setDisturbMode(!this.serviceStore.disturbMode)
    ToastUtils.show(this.serviceStore.disturbMode ? '请勿打扰已开启' : '请勿打扰已关闭')
  }

  toggleCleanRoom(): void {
    this.serviceStore.setCleanRoom(!this.serviceStore.cleanRoom)
    ToastUtils.show(this.serviceStore.cleanRoom ? '清理房间已预约' : '清理房间已取消')
  }

  toggleLeftNightLight(): void {
    this.leftNightLightOn = !this.leftNightLightOn
    ToastUtils.show(this.leftNightLightOn ? '左夜灯已开启' : '左夜灯已关闭')
  }

  toggleRightNightLight(): void {
    this.rightNightLightOn = !this.rightNightLightOn
    ToastUtils.show(this.rightNightLightOn ? '右夜灯已开启' : '右夜灯已关闭')
  }

  toggleGoodNightMode(): void {
    // 总开关关闭时不允许开启晚安模式
    if (!this.lightSceneStore.mainSwitch && !this.goodNightModeOn) {
      ToastUtils.show('请先开启灯光总开关')
      return
    }
    if (this.goodNightModeOn) {
      // 关闭晚安模式：恢复之前的灯光场景
      this.goodNightModeOn = false
      this.lightSceneStore.setLightScene(this.previousLightScene)
      ToastUtils.show('晚安模式已关闭')
    } else {
      // 开启晚安模式：保存当前灯光场景并切换到入睡模式(5)
      this.previousLightScene = this.lightSceneStore.lightScene
      this.goodNightModeOn = true
      this.lightSceneStore.setLightScene(5)  // 入住模式/入睡模式
      ToastUtils.show('晚安模式已开启')
    }
  }

  async enterGoodNightMode(): Promise<void> {
    this.isGoodNightExecuting = true

    setTimeout(() => {
      this.isGoodNightExecuting = false
      ToastUtils.show('晚安模式已开启')
    }, 300)
  }

  async exitGoodNightMode(): Promise<void> {
    this.isGoodNightExecuting = true

    setTimeout(() => {
      this.isGoodNightExecuting = false
      ToastUtils.show('晚安模式已关闭')
    }, 300)
  }
}
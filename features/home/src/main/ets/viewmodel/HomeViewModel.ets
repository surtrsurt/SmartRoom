// 首页ViewModel
// 查拉图斯特拉如是说

import { hilog } from '@kit.PerformanceAnalysisKit'
import { TokenStore } from 'common_datastore'
import { RoomStore } from 'common_datastore'
import { LightSceneStore } from 'common_datastore'
import { ToastUtils } from 'common_uicomponents'
import { HomeRepository } from '../repository/HomeRepository.ets'
import { AirRepository } from 'features_air'
import type { RoomState } from '../model/HomeModel.ets'

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
  @Trace airMode: number = 0
  @Trace airTemp: number = 24
  @Trace airSpeed: number = 0
  @Trace goodNightModeOn: boolean = false
  // 服务状态（选中效果需要@Trace）
  @Trace disturbModeOn: boolean = false
  @Trace cleanRoomOn: boolean = false
  // 保存关闭晚安模式前灯光场景
  private previousLightScene: number = 1

  // 共享灯光场景Store
  lightSceneStore: LightSceneStore = LightSceneStore.getInstance()

  private repository = new HomeRepository()
  private airRepository = new AirRepository()
  private tokenStore = TokenStore.getInstance()
  private roomStore = RoomStore.getInstance()

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

    this.isLoading = true

    try {
      const state = await this.repository.getState(token, roomNo)
      hilog.info(0x0000, 'HomeViewModel', 'getState result: roomNo=%{public}s, firstName=%{public}s', state.roomNo, state.firstName)
      this.roomNo = state.roomNo
      this.firstName = state.firstName
      this.roomState = state
      // 同步追踪的空调状态（从持久化存储恢复数据）
      const savedAir = this.roomStore.getAirState()
      if (state.air) {
        this.airPower = savedAir?.power ?? state.air.power
        this.airTemp = savedAir?.temp ?? state.air.temp
        this.airMode = savedAir?.mode ?? state.air.mode
        this.airSpeed = savedAir?.speed ?? state.air.speed
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

  async setAirTemp(temp: number): Promise<void> {
    this.airTemp = temp
    this.roomStore.setAirState({ power: this.airPower, mode: this.airMode, temp: temp, speed: this.airSpeed })
    if (this.roomState && this.roomState.air) {
      const old = this.roomState.air
      this.roomState.air = { power: old.power, mode: old.mode, speed: old.speed, temp: temp }
    }
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

  setAirMode(mode: number): void {
    // 空调关闭时不允许切换模式
    if (!this.airPower) {
      ToastUtils.show('请先开启空调')
      return
    }
    if (this.airMode === mode) {
      this.airMode = -1
    } else {
      this.airMode = mode
    }
    this.roomStore.setAirState({ power: this.airPower, mode: this.airMode, temp: this.airTemp, speed: this.airSpeed })
    if (this.roomState && this.roomState.air) {
      const old = this.roomState.air
      this.roomState.air = { power: old.power, mode: this.airMode, speed: old.speed, temp: old.temp }
    }
  }

  async setAirPower(power: boolean): Promise<void> {
    if (power) {
      // 开启空调：恢复默认自动模式
      this.airPower = true
      this.airMode = 0
    } else {
      // 关闭空调：关闭自动模式和强劲模式
      this.airPower = false
      this.airMode = -1
    }
    this.roomStore.setAirState({ power: this.airPower, mode: this.airMode, temp: this.airTemp, speed: this.airSpeed })
    if (this.roomState && this.roomState.air) {
      const old = this.roomState.air
      this.roomState.air = { power: this.airPower, mode: this.airMode, speed: old.speed, temp: old.temp }
    }
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
    // 如果晚安模式开启中，不允许切换场景
    if (this.goodNightModeOn) {
      ToastUtils.show('晚安模式已开启，请先关闭')
      return
    }
    // 通过共享Store设置场景
    this.lightSceneStore.setLightScene(scene)
  }

  toggleDisturbMode(): void {
    this.disturbModeOn = !this.disturbModeOn
    ToastUtils.show(this.disturbModeOn ? '请勿打扰已开启' : '请勿打扰已关闭')
  }

  toggleCleanRoom(): void {
    this.cleanRoomOn = !this.cleanRoomOn
    ToastUtils.show(this.cleanRoomOn ? '清理房间已预约' : '清理房间已取消')
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
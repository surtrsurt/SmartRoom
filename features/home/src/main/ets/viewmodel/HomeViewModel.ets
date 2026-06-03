// 首页ViewModel
// 查拉图斯特拉如是说

import { hilog } from '@kit.PerformanceAnalysisKit'
import { TokenStore } from 'common_datastore'
import { RoomStore } from 'common_datastore'
import { ToastUtils } from 'common_uicomponents'
import { HomeRepository } from '../repository/HomeRepository.ets'
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
  @Trace lightScene: number = 1
  @Trace goodNightModeOn: boolean = false

  private repository = new HomeRepository()
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
        this.lightScene = state.lights.scene
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
    return this.roomState?.disturbMode ?? false
  }

  get cleanRoom(): boolean {
    return this.roomState?.cleanRoom ?? false
  }

  setAirTemp(temp: number): void {
    this.airTemp = temp
    this.roomStore.setAirState({ power: this.airPower, mode: this.airMode, temp: temp, speed: this.airSpeed })
    if (this.roomState && this.roomState.air) {
      const old = this.roomState.air
      this.roomState.air = { power: old.power, mode: old.mode, speed: old.speed, temp: temp }
    }
  }

  setAirMode(mode: number): void {
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

  setAirPower(power: boolean): void {
    this.airPower = power
    this.roomStore.setAirState({ power: power, mode: this.airMode, temp: this.airTemp, speed: this.airSpeed })
    if (this.roomState && this.roomState.air) {
      const old = this.roomState.air
      this.roomState.air = { power: power, mode: old.mode, speed: old.speed, temp: old.temp }
    }
  }

  setLightScene(scene: number): void {
    this.lightScene = scene
    if (this.roomState) {
      this.roomState.lights.scene = scene
    }
  }

  toggleDisturbMode(): void {
    if (this.roomState) {
      this.roomState.disturbMode = !this.roomState.disturbMode
    }
  }

  toggleCleanRoom(): void {
    if (this.roomState) {
      this.roomState.cleanRoom = !this.roomState.cleanRoom
    }
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
    this.goodNightModeOn = !this.goodNightModeOn
    ToastUtils.show(this.goodNightModeOn ? '晚安模式已开启' : '晚安模式已关闭')
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
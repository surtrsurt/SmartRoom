// 首页模型
// 查拉图斯特拉如是说

export interface RoomState {
  roomNo: string
  firstName: string
  lights: LightState
  air: AirState
  curtains: CurtainState
  disturbMode: boolean
  cleanRoom: boolean
}

export interface LightState {
  mainSwitch: boolean
  scene: number
  hardwareList: HardwareItem[]
}

export interface HardwareItem {
  id: number
  name: string
  on: boolean
}

export interface AirState {
  power: boolean
  mode: number
  temp: number
  speed: number
}

export interface CurtainState {
  leftCurtain: number
  rightCurtain: number
  leftSheer: number
  rightSheer: number
}
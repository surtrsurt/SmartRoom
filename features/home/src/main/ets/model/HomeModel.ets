// 首页模型
// 查拉图斯特拉如是说

import type { LightState, AirState, CurtainState } from 'common_datastore'

export interface RoomState {
  roomNo: string
  firstName: string
  lights: LightState
  air: AirState
  curtains: CurtainState
  disturbMode: boolean
  cleanRoom: boolean
}
// Mock首页服务
// 查拉图斯特拉如是说

export interface ApiResponse<T> {
  code: number
  msg: string
  data?: T
}

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

export class MockHomeService {
  static async getRoomState(roomNo: string): Promise<ApiResponse<RoomState>> {
    await new Promise<void>(resolve => setTimeout(resolve, 500))
    const data: RoomState = {
      roomNo: roomNo || '8888',
      firstName: '张三',
      lights: {
        mainSwitch: true,
        scene: 1,
        hardwareList: [
          { id: 1, name: '廊灯', on: true },
          { id: 2, name: '洗漱间灯', on: false },
          { id: 3, name: '排风扇', on: false },
          { id: 4, name: '左阅读灯', on: false },
          { id: 5, name: '右阅读灯', on: false },
          { id: 6, name: '书桌灯', on: false },
          { id: 7, name: '吧灯', on: false },
          { id: 8, name: '衣柜灯', on: false }
        ]
      },
      air: {
        power: true,
        mode: 0,
        temp: 26,
        speed: 1
      },
      curtains: {
        leftCurtain: 0,
        rightCurtain: 0,
        leftSheer: 0,
        rightSheer: 0
      },
      disturbMode: false,
      cleanRoom: false
    }
    const result: ApiResponse<RoomState> = {
      code: 0,
      msg: 'success',
      data: data
    }
    return result
  }
}
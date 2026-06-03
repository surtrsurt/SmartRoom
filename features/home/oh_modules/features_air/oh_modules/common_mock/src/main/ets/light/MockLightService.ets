// Mock灯光服务
// 查拉图斯特拉如是说

export class MockLightService {
  static async setLightMode(request: LightControlRequest): Promise<boolean> {
    await new Promise<void>(resolve => setTimeout(resolve, 300))
    return true
  }

  static async controlHardware(request: LightControlRequest): Promise<boolean> {
    await new Promise<void>(resolve => setTimeout(resolve, 300))
    return true
  }

  static getHardwareList(): LightHardwareInfo[] {
    const list: LightHardwareInfo[] = [
      { id: 1, name: '廊灯', on: false },
      { id: 2, name: '洗漱间灯', on: false },
      { id: 3, name: '排风扇', on: false },
      { id: 4, name: '左阅读灯', on: false },
      { id: 5, name: '右阅读灯', on: false },
      { id: 6, name: '书桌灯', on: false },
      { id: 7, name: '吧灯', on: false },
      { id: 8, name: '衣柜灯', on: false }
    ]
    return list
  }
}

export interface LightControlRequest {
  scene?: number
  hardwareId?: number
  on?: boolean
}

export interface LightHardwareInfo {
  id: number
  name: string
  on: boolean
}
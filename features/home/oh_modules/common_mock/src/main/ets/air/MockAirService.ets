// Mock空调服务
// 查拉图斯特拉如是说

interface AirModeInfo {
  mode: number
  name: string
}

interface AirSpeedInfo {
  speed: number
  name: string
}

export class MockAirService {
  static async clickAirBtn(request: AirControlRequest): Promise<boolean> {
    await new Promise<void>(resolve => setTimeout(resolve, 300))
    return true
  }

  static getAirModes(): AirModeInfo[] {
    const modes: AirModeInfo[] = [
      { mode: 0, name: '制冷' },
      { mode: 1, name: '制热' },
      { mode: 2, name: '自动' },
      { mode: 3, name: '送风' }
    ]
    return modes
  }

  static getAirSpeeds(): AirSpeedInfo[] {
    const speeds: AirSpeedInfo[] = [
      { speed: 0, name: '自动' },
      { speed: 1, name: '低' },
      { speed: 2, name: '中' },
      { speed: 3, name: '高' }
    ]
    return speeds
  }
}

export interface AirControlRequest {
  cmd: string
  value?: number
}
// 空调模型
// 查拉图斯特拉如是说

export interface AirControlRequest {
  cmd: string
  value?: number
}

export interface AirState {
  power: boolean
  mode: number
  temp: number
  speed: number
}

export enum AirMode {
  COOL = 0,
  HEAT = 1,
  AUTO = 2,
  WIND = 3
}

export enum AirSpeed {
  AUTO = 0,
  LOW = 1,
  MEDIUM = 2,
  HIGH = 3
}

export class AirModeNames {
  static readonly COOL: string = '制冷'
  static readonly HEAT: string = '制热'
  static readonly AUTO: string = '自动'
  static readonly WIND: string = '送风'

  static getName(mode: number): string {
    // UI层使用的模式值: 0=自动模式, 1=强劲模式
    if (mode === 0) return '自动模式'
    if (mode === 1) return '强劲模式'
    // 底层空调模式: 2=制冷, 3=制热, 4=送风, 5=自动
    if (mode === 2) return '制冷'
    if (mode === 3) return '制热'
    if (mode === 4) return '送风'
    if (mode === 5) return '自动'
    return '自动模式'
  }
}

export class AirSpeedNames {
  static readonly AUTO: string = '自动'
  static readonly LOW: string = '低'
  static readonly MEDIUM: string = '中'
  static readonly HIGH: string = '高'

  static getName(speed: number): string {
    if (speed === AirSpeed.AUTO) return '自动'
    if (speed === AirSpeed.LOW) return '低'
    if (speed === AirSpeed.MEDIUM) return '中'
    if (speed === AirSpeed.HIGH) return '高'
    return '自动'
  }
}
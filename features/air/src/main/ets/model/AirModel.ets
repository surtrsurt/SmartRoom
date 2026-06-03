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

// 空调模式（UI层使用）
// 0=自动模式, 1=强劲模式
export enum AirMode {
  AUTO = 0,
  POWERFUL = 1
}

// 空调风速（根据接口文档）
// cmd=speed: 0=自动, 1=低, 2=中, 3=高
export enum AirSpeed {
  AUTO = 0,
  LOW = 1,
  MEDIUM = 2,
  HIGH = 3
}

export class AirModeNames {
  static readonly AUTO: string = '自动模式'
  static readonly POWERFUL: string = '强劲模式'

  static getName(mode: number): string {
    switch (mode) {
      case AirMode.AUTO: return '自动模式'
      case AirMode.POWERFUL: return '强劲模式'
      default: return '自动模式'
    }
  }
}

export class AirSpeedNames {
  static readonly AUTO: string = '自动'
  static readonly LOW: string = '低'
  static readonly MEDIUM: string = '中'
  static readonly HIGH: string = '高'

  static getName(speed: number): string {
    switch (speed) {
      case AirSpeed.AUTO: return '自动'
      case AirSpeed.LOW: return '低'
      case AirSpeed.MEDIUM: return '中'
      case AirSpeed.HIGH: return '高'
      default: return '自动'
    }
  }
}
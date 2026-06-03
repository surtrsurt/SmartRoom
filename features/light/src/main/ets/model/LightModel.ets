// 灯光模型
// 查拉图斯特拉如是说

export interface LightHardwareInfo {
  id: number
  name: string
  on: boolean
}

export interface LightControlRequest {
  scene?: number
  hardwareId?: number
  on?: boolean
}

export enum LightScene {
  NONE = 0,
  BRIGHT = 1,
  SOFT = 2,
  READ = 3,
  WARM = 4,
  SLEEP = 5
}
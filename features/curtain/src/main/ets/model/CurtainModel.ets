// 窗帘模型
// 查拉图斯特拉如是说

export interface CurtainState {
  leftCurtain: number
  rightCurtain: number
  leftSheer: number
  rightSheer: number
}

export interface CurtainControlRequest {
  type: 'curtain' | 'sheer'
  action: 'open' | 'close' | 'pause'
}

export enum CurtainPosition {
  CLOSED = 0,
  PARTIAL = 50,
  OPEN = 100
}
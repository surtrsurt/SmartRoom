// Mock窗帘服务
// 查拉图斯特拉如是说

export class MockCurtainService {
  static async controlCurtain(request: CurtainControlRequest): Promise<boolean> {
    await new Promise<void>(resolve => setTimeout(resolve, 300))
    return true
  }

  static getCurtainState(): CurtainState {
    const state: CurtainState = {
      leftCurtain: 0,
      rightCurtain: 0,
      leftSheer: 0,
      rightSheer: 0
    }
    return state
  }
}

export interface CurtainControlRequest {
  type: 'curtain' | 'sheer'
  action: 'open' | 'close' | 'pause'
}

export interface CurtainState {
  leftCurtain: number
  rightCurtain: number
  leftSheer: number
  rightSheer: number
}
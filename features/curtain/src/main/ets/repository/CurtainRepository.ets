// 窗帘Repository
// 查拉图斯特拉如是说

import { MockCurtainService, type CurtainControlRequest, type CurtainState } from 'common_mock'

export class CurtainRepository {
  async controlCurtain(request: CurtainControlRequest): Promise<boolean> {
    return await MockCurtainService.controlCurtain(request)
  }

  getInitialState(): CurtainState {
    return MockCurtainService.getCurtainState()
  }
}
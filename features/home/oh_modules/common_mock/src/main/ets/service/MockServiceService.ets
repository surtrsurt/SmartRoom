// Mock服务模块
// 查拉图斯特拉如是说

export class MockServiceService {
  static async controlService(request: ServiceControlRequest): Promise<boolean> {
    await new Promise<void>(resolve => setTimeout(resolve, 500))
    return true
  }

  static async requestSOS(): Promise<boolean> {
    await new Promise<void>(resolve => setTimeout(resolve, 2000))
    return true
  }
}

export interface ServiceControlRequest {
  type: 'disturb' | 'clean' | 'sos' | 'checkout'
}
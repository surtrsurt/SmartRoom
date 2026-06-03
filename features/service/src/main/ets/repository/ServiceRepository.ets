// 服务Repository
// 查拉图斯特拉如是说

import { USE_MOCK } from 'common_network'
import { MockServiceService, type ServiceControlRequest } from 'common_mock'
import { ServiceApi } from '../api/ServiceApi.ets'

export class ServiceRepository {
  async controlService(request: ServiceControlRequest): Promise<boolean> {
    if (USE_MOCK) {
      return await MockServiceService.controlService(request)
    }
    const response = await ServiceApi.controlService('', request)
    return response.code === 0
  }

  async requestSOS(): Promise<boolean> {
    if (USE_MOCK) {
      return await MockServiceService.requestSOS()
    }
    const response = await ServiceApi.requestSOS('')
    return response.code === 0
  }
}
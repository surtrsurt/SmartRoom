// 灯光Repository
// 查拉图斯特拉如是说

import { USE_MOCK } from 'common_network'
import { MockLightService, type LightControlRequest } from 'common_mock'
import { LightApi } from '../api/LightApi.ets'

export class LightRepository {
  async setLightMode(token: string, request: LightControlRequest): Promise<boolean> {
    if (USE_MOCK) {
      return await MockLightService.setLightMode(request)
    }
    const response = await LightApi.setLightMode(token, request)
    return response.code === 0
  }

  async controlHardware(token: string, request: LightControlRequest): Promise<boolean> {
    if (USE_MOCK) {
      return await MockLightService.controlHardware(request)
    }
    const response = await LightApi.setLightMode(token, request)
    return response.code === 0
  }
}
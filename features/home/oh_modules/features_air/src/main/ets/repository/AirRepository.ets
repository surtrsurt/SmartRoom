// 空调Repository
// 查拉图斯特拉如是说

import { USE_MOCK } from 'common_network'
import { MockAirService, type AirControlRequest } from 'common_mock'
import { AirApi } from '../api/AirApi.ets'

export class AirRepository {
  async clickAirBtn(token: string, request: AirControlRequest): Promise<boolean> {
    if (USE_MOCK) {
      return await MockAirService.clickAirBtn(request)
    }
    const response = await AirApi.clickAirBtn(token, request)
    return response.code === 0
  }
}
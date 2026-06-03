// 灯光API
// 查拉图斯特拉如是说

import { HttpService } from 'common_network'
import type { LightControlRequest } from 'common_mock'

const SET_LIGHT_MODE_URL = '/api/rcu/room/setLightMode'

export interface ApiResponse<T> {
  code: number
  msg: string
  data?: T
}

export class LightApi {
  static async setLightMode(token: string, request: LightControlRequest): Promise<ApiResponse<null>> {
    const http = HttpService.getInstance()
    const data = JSON.stringify(request)
    return http.post<null>(SET_LIGHT_MODE_URL, token, data)
  }
}
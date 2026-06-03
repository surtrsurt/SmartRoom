// 空调API
// 查拉图斯特拉如是说

import { HttpService } from 'common_network'
import type { AirControlRequest } from 'common_mock'

const CLICK_AIR_BTN_URL = '/api/rcu/room/clickAirBtn'

export interface ApiResponse<T> {
  code: number
  msg: string
  data?: T
}

export class AirApi {
  static async clickAirBtn(token: string, request: AirControlRequest): Promise<ApiResponse<null>> {
    const http = HttpService.getInstance()
    const data = JSON.stringify(request)
    return http.post<null>(CLICK_AIR_BTN_URL, token, data)
  }
}
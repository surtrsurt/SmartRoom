// 服务API
// 查拉图斯特拉如是说

import { HttpService } from 'common_network'
import type { ServiceControlRequest } from 'common_mock'

const SERVICE_CONTROL_URL = '/api/rcu/room/service/control'
const SOS_REQUEST_URL = '/api/rcu/room/sos'

export interface ApiResponse<T> {
  code: number
  msg: string
  data?: T
}

export class ServiceApi {
  static async controlService(token: string, request: ServiceControlRequest): Promise<ApiResponse<null>> {
    const http = HttpService.getInstance()
    const data = JSON.stringify(request)
    return http.post<null>(SERVICE_CONTROL_URL, token, data)
  }

  static async requestSOS(token: string): Promise<ApiResponse<null>> {
    const http = HttpService.getInstance()
    return http.post<null>(SOS_REQUEST_URL, token, '')
  }
}
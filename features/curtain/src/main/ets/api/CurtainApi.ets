// 窗帘API
// 查拉图斯特拉如是说

import { HttpService } from 'common_network'
import type { CurtainControlRequest } from '../model/CurtainModel.ets'

const CURTAIN_CONTROL_URL = '/api/rcu/room/curtain/control'

export class CurtainApi {
  static async controlCurtain(token: string, request: CurtainControlRequest): Promise<ApiResponse<null>> {
    const http = HttpService.getInstance()
    const data = JSON.stringify(request)
    return http.post<null>(CURTAIN_CONTROL_URL, token, data)
  }
}

interface ApiResponse<T> {
  code: number
  msg: string
  data?: T
}
// 首页API
// 查拉图斯特拉如是说

import { HttpService } from 'common_network'
import type { RoomState } from '../model/HomeModel.ets'

const GET_STATE_URL = '/api/rcu/room/getState'

export interface ApiResponse<T> {
  code: number
  msg: string
  data?: T
}

export class HomeApi {
  static async getState(token: string, roomNo: string): Promise<ApiResponse<RoomState>> {
    const http = HttpService.getInstance()
    const data = JSON.stringify({ roomNo: roomNo })
    return http.post<RoomState>(GET_STATE_URL, token, data)
  }
}
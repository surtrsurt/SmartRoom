// 首页Repository
// 查拉图斯特拉如是说

import { USE_MOCK } from 'common_network'
import { MockHomeService } from 'common_mock'
import { HomeApi } from '../api/HomeApi.ets'
import type { RoomState } from '../model/HomeModel.ets'

export class HomeRepository {
  async getState(token: string, roomNo: string): Promise<RoomState> {
    if (USE_MOCK) {
      const result = await MockHomeService.getRoomState(roomNo)
      if (result.data) {
        return result.data
      }
      throw new Error('Failed to get room state')
    }
    const response = await HomeApi.getState(token, roomNo)
    if (response.data) {
      return response.data
    }
    throw new Error('Failed to get room state')
  }
}
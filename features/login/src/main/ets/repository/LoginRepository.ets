// 登录Repository
// 查拉图斯特拉如是说

import { USE_MOCK } from 'common_network'
import { MockLoginService, type LoginRequest } from 'common_mock'
import { LoginApi } from '../api/LoginApi.ets'
import type { LoginResponse } from '../model/LoginModel.ets'

export class LoginRepository {
  async login(request: LoginRequest): Promise<LoginResponse> {
    if (USE_MOCK) {
      const result = await MockLoginService.login(request)
      return result
    }
    const response = await LoginApi.login(request)
    if (response.data) {
      return response.data
    }
    throw new Error('Login failed')
  }
}
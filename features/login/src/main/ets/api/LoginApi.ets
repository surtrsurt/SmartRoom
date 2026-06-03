// 登录API
// 查拉图斯特拉如是说

import { HttpService } from 'common_network'
import type { LoginRequest } from 'common_mock'
import type { LoginResponse } from '../model/LoginModel.ets'

const LOGIN_URL = '/api/sso/login'

export interface ApiResponse<T> {
  code: number
  msg: string
  data?: T
}

export class LoginApi {
  static async login(request: LoginRequest): Promise<ApiResponse<LoginResponse>> {
    const http = HttpService.getInstance()
    const data = JSON.stringify(request)
    return http.post<LoginResponse>(LOGIN_URL, '', data)
  }
}
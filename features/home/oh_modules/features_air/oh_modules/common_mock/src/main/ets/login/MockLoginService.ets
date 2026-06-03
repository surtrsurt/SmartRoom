// Mock登录服务
// 查拉图斯特拉如是说

import { ApiResponse } from 'common_network'

export interface LoginRequest {
  roomNo: string
  userName: string
  password: string
  remember: boolean
}

export interface LoginResult {
  token: string
  roomNo: string
  firstName: string
}

export class MockLoginService {
  static async login(request: LoginRequest): Promise<LoginResponse> {
    await new Promise<void>(resolve => setTimeout(resolve, 500))

    if (request.roomNo === '2002' && request.userName === 'xiao') {
      return {
        token: 'mock_token_' + Date.now().toString(),
        roomNo: request.roomNo,
        firstName: '张三'
      }
    }
    throw new Error('房间号或用户名密码错误')
  }

  static async logout(): Promise<void> {
    await new Promise<void>(resolve => setTimeout(resolve, 300))
  }
}

export interface LoginResponse {
  token: string
  roomNo: string
  firstName: string
}
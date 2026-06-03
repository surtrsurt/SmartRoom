// 登录请求模型
// 查拉图斯特拉如是说

export interface LoginRequest {
  roomNo: string
  userName: string
  password: string
  remember: boolean
}

export interface LoginResponse {
  token: string
  roomNo: string
  firstName: string
}
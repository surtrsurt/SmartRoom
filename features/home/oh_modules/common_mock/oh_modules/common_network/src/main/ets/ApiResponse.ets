// API响应结构
// 查拉图斯特拉如是说

export interface ApiResponse<T> {
  code: number
  msg: string
  data?: T
}

export interface ApiError {
  type: ErrorType
  message: string
}

export enum ErrorType {
  TOKEN_EXPIRED = 'TOKEN_EXPIRED',
  SERVER_ERROR = 'SERVER_ERROR',
  NETWORK_ERROR = 'NETWORK_ERROR',
  UNKNOWN = 'UNKNOWN'
}
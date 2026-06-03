// 服务模型
// 查拉图斯特拉如是说

export interface ServiceControlRequest {
  type: 'disturb' | 'clean' | 'sos' | 'checkout'
}

export enum ServiceType {
  DISTURB = 'disturb',
  CLEAN = 'clean',
  SOS = 'sos',
  CHECKOUT = 'checkout'
}
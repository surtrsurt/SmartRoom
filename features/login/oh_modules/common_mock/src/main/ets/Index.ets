// Common Mock Module - Mock数据服务
// 查拉图斯特拉如是说

export { MockLoginService } from './login/MockLoginService.ets'
export type { LoginRequest, LoginResponse } from './login/MockLoginService.ets'

export { MockHomeService } from './home/MockHomeService.ets'
export type { RoomState, LightState, HardwareItem, AirState, CurtainState } from './home/MockHomeService.ets'

export { MockLightService } from './light/MockLightService.ets'
export type { LightControlRequest, LightHardwareInfo } from './light/MockLightService.ets'

export { MockAirService } from './air/MockAirService.ets'
export type { AirControlRequest } from './air/MockAirService.ets'

export { MockCurtainService } from './curtain/MockCurtainService.ets'
export type { CurtainControlRequest } from './curtain/MockCurtainService.ets'

export { MockServiceService } from './service/MockServiceService.ets'
export type { ServiceControlRequest } from './service/MockServiceService.ets'
// 登录ViewModel
// 查拉图斯特拉如是说

import { hilog } from '@kit.PerformanceAnalysisKit'
import { TokenStore } from 'common_datastore'
import { ValidateUtils } from 'common_utils'
import { ToastUtils } from 'common_uicomponents'
import { LoginRepository } from '../repository/LoginRepository.ets'
import type { LoginRequest } from 'common_mock'

@ObservedV2
export class LoginViewModel {
  @Trace roomNo: string = ''
  @Trace userName: string = ''
  @Trace rememberMe: boolean = true
  @Trace isLoading: boolean = false

  private repository: LoginRepository = new LoginRepository()
  private tokenStore: TokenStore = TokenStore.getInstance()

  setRoomNo(value: string): void {
    this.roomNo = value
  }

  setUserName(value: string): void {
    this.userName = value
  }

  setRememberMe(value: boolean): void {
    this.rememberMe = value
  }

  async login(): Promise<boolean> {
    if (ValidateUtils.isEmpty(this.roomNo)) {
      ToastUtils.show('请输入房间号')
      return false
    }

    if (ValidateUtils.isEmpty(this.userName)) {
      ToastUtils.show('请输入用户名')
      return false
    }

    if (!ValidateUtils.isValidRoomNo(this.roomNo)) {
      ToastUtils.show('房间号必须是4位数字')
      return false
    }

    this.isLoading = true

    try {
      const req: LoginRequest = {
        roomNo: this.roomNo,
        userName: this.userName,
        password: '',
        remember: this.rememberMe
      }
      hilog.info(0x0000, 'LoginViewModel', 'login: req.roomNo=%{public}s, req.userName=%{public}s', req.roomNo, req.userName)
      const result = await this.repository.login(req)

      hilog.info(0x0000, 'LoginViewModel', 'login result: roomNo=%{public}s, firstName=%{public}s', result.roomNo, result.firstName)
      this.tokenStore.setToken(result.token)
      this.tokenStore.setRoomNo(result.roomNo)
      this.tokenStore.setFirstName(result.firstName)
      this.tokenStore.setLoginTime(Date.now())

      hilog.info(0x0000, 'LoginViewModel', 'tokenStore setRoomNo done, getRoomNo=%{public}s', this.tokenStore.getRoomNo())
      return true
    } catch (error) {
      hilog.error(0x0000, 'LoginViewModel', 'login error: %{public}s', JSON.stringify(error))
      ToastUtils.show('登录失败')
      return false
    } finally {
      this.isLoading = false
    }
  }
}
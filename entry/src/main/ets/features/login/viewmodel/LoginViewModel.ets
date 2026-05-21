import { LoginModel } from '../model/LoginModel'
import { PreferencesHelper } from '../../../common/helper/PreferencesHelper'

export class LoginViewModel {
  private loginModel: LoginModel = new LoginModel()

  // 状态
  roomNo: string = ''
  firstName: string = ''
  isRememberChecked: boolean = true
  isLoading: boolean = false
  errorMsg: string = ''

  // 持久化状态
  token: string = ''

  constructor() {}

  setRoomNo(value: string): void {
    this.roomNo = value
  }

  setFirstName(value: string): void {
    this.firstName = value
  }

  toggleRemember(): void {
    this.isRememberChecked = !this.isRememberChecked
  }

  async login(): Promise<boolean> {
    if (!this.roomNo || !this.firstName) {
      this.errorMsg = '请输入客房号和姓名'
      return false
    }

    this.isLoading = true
    this.errorMsg = ''

    // 模拟登录延迟
    await new Promise<void>((resolve: Function) => setTimeout(resolve, 500))

    const token = this.loginModel.mockLogin(this.roomNo, this.firstName)

    if (token) {
      // 存储到 AppStorage
      AppStorage.setOrCreate('token', token)
      AppStorage.setOrCreate('rememberChecked', this.isRememberChecked)

      // 持久化到 Preferences
      const prefHelper = PreferencesHelper.getInstance()
      prefHelper.set('token', token)
      prefHelper.set('rememberChecked', this.isRememberChecked)

      if (this.isRememberChecked) {
        prefHelper.set('roomNo', this.roomNo)
      } else {
        prefHelper.delete('roomNo')
      }

      await prefHelper.flush()

      this.isLoading = false
      return true
    } else {
      this.errorMsg = '客房号或用户名错误'
      this.isLoading = false
      return false
    }
  }

  loadSavedState(): void {
    const prefHelper = PreferencesHelper.getInstance()
    const savedRememberChecked = prefHelper.get('rememberChecked', true) as boolean

    this.isRememberChecked = savedRememberChecked

    if (savedRememberChecked) {
      const savedRoomNo = prefHelper.get('roomNo', '') as string
      if (savedRoomNo) {
        this.roomNo = savedRoomNo
      }
    }
  }
}
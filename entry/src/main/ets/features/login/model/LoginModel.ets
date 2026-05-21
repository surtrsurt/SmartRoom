export class LoginModel {
  mockLogin(roomNo: string, firstName: string): string | null {
    // 固定测试账号: roomNo=2004, firstName=lin
    if (roomNo === '2004' && firstName === 'lin') {
      return 'mock_token_12345'
    }
    return null
  }
}
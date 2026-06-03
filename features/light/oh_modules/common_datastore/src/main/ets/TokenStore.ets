// Token存储
// 查拉图斯特拉如是说

import { preferences } from '@kit.ArkData'
import { BusinessError } from '@kit.BasicServicesKit'

const TOKEN_PREFERENCES_NAME = 'token_prefs'
const KEY_TOKEN = 'token'
const KEY_ROOM_NO = 'roomNo'
const KEY_FIRST_NAME = 'firstName'
const KEY_LOGIN_TIME = 'loginTime'
const TOKEN_EXPIRE_HOURS = 24

export class TokenStore {
  private static instance: TokenStore
  private prefs: preferences.Preferences | null = null

  private constructor() {}

  static getInstance(): TokenStore {
    if (!TokenStore.instance) {
      TokenStore.instance = new TokenStore()
    }
    return TokenStore.instance
  }

  async init(context: Context): Promise<void> {
    try {
      this.prefs = preferences.getPreferencesSync(context, {
        name: TOKEN_PREFERENCES_NAME
      })
    } catch (error) {
      console.error('TokenStore init failed:', error)
    }
  }

  setToken(token: string): void {
    if (this.prefs) {
      this.prefs.putSync(KEY_TOKEN, token)
      this.prefs.flushSync()
    }
  }

  getToken(): string {
    if (this.prefs) {
      return this.prefs.getSync(KEY_TOKEN, '') as string
    }
    return ''
  }

  setRoomNo(roomNo: string): void {
    if (this.prefs) {
      this.prefs.putSync(KEY_ROOM_NO, roomNo)
      this.prefs.flushSync()
    }
  }

  getRoomNo(): string {
    if (this.prefs) {
      return this.prefs.getSync(KEY_ROOM_NO, '') as string
    }
    return ''
  }

  setFirstName(firstName: string): void {
    if (this.prefs) {
      this.prefs.putSync(KEY_FIRST_NAME, firstName)
      this.prefs.flushSync()
    }
  }

  getFirstName(): string {
    if (this.prefs) {
      return this.prefs.getSync(KEY_FIRST_NAME, '') as string
    }
    return ''
  }

  setLoginTime(time: number): void {
    if (this.prefs) {
      this.prefs.putSync(KEY_LOGIN_TIME, time)
      this.prefs.flushSync()
    }
  }

  getLoginTime(): number {
    if (this.prefs) {
      return this.prefs.getSync(KEY_LOGIN_TIME, 0) as number
    }
    return 0
  }

  isTokenExpired(): boolean {
    const loginTime = this.getLoginTime()
    if (loginTime === 0) {
      return true
    }
    const now = Date.now()
    const expireMillis = TOKEN_EXPIRE_HOURS * 60 * 60 * 1000
    return now - loginTime > expireMillis
  }

  clearToken(): void {
    if (this.prefs) {
      this.prefs.deleteSync(KEY_TOKEN)
      this.prefs.deleteSync(KEY_LOGIN_TIME)
      this.prefs.deleteSync(KEY_FIRST_NAME)
      this.prefs.flushSync()
    }
  }

  clearAll(): void {
    if (this.prefs) {
      this.prefs.deleteSync(KEY_TOKEN)
      this.prefs.deleteSync(KEY_ROOM_NO)
      this.prefs.deleteSync(KEY_FIRST_NAME)
      this.prefs.deleteSync(KEY_LOGIN_TIME)
      this.prefs.flushSync()
    }
  }
}
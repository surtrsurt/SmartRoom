// 服务状态共享存储（请勿打扰/清理房间）
// 查拉图斯特拉如是说

import { preferences } from '@kit.ArkData'

const SERVICE_PREFERENCES_NAME = 'service_prefs'
const KEY_DISTURB_MODE = 'disturbMode'
const KEY_CLEAN_ROOM = 'cleanRoom'

@ObservedV2
export class ServiceStore {
  private static instance: ServiceStore
  private prefs: preferences.Preferences | null = null

  @Trace disturbMode: boolean = false
  @Trace cleanRoom: boolean = false

  // 状态变化监听器
  private disturbListeners: Array<(enabled: boolean) => void> = []
  private cleanListeners: Array<(enabled: boolean) => void> = []

  private constructor() {}

  static getInstance(): ServiceStore {
    if (!ServiceStore.instance) {
      ServiceStore.instance = new ServiceStore()
    }
    return ServiceStore.instance
  }

  async init(context: Context): Promise<void> {
    try {
      this.prefs = preferences.getPreferencesSync(context, {
        name: SERVICE_PREFERENCES_NAME
      })
      this.loadFromPrefs()
    } catch (error) {
      console.error('ServiceStore init failed:', error)
    }
  }

  private loadFromPrefs(): void {
    if (this.prefs) {
      this.disturbMode = this.prefs.getSync(KEY_DISTURB_MODE, false) as boolean
      this.cleanRoom = this.prefs.getSync(KEY_CLEAN_ROOM, false) as boolean
    }
  }

  // 设置请勿打扰
  setDisturbMode(enabled: boolean): void {
    this.disturbMode = enabled
    if (this.prefs) {
      this.prefs.putSync(KEY_DISTURB_MODE, enabled)
      this.prefs.flushSync()
    }
    // 通知监听器
    this.disturbListeners.forEach(listener => listener(enabled))
  }

  // 设置清理房间
  setCleanRoom(enabled: boolean): void {
    this.cleanRoom = enabled
    if (this.prefs) {
      this.prefs.putSync(KEY_CLEAN_ROOM, enabled)
      this.prefs.flushSync()
    }
    // 通知监听器
    this.cleanListeners.forEach(listener => listener(enabled))
  }

  // 注册请勿打扰变化监听
  registerDisturbListener(listener: (enabled: boolean) => void): void {
    this.disturbListeners.push(listener)
  }

  // 注册清理房间变化监听
  registerCleanListener(listener: (enabled: boolean) => void): void {
    this.cleanListeners.push(listener)
  }

  // 注销监听
  unregisterDisturbListener(listener: (enabled: boolean) => void): void {
    const index = this.disturbListeners.indexOf(listener)
    if (index > -1) {
      this.disturbListeners.splice(index, 1)
    }
  }

  unregisterCleanListener(listener: (enabled: boolean) => void): void {
    const index = this.cleanListeners.indexOf(listener)
    if (index > -1) {
      this.cleanListeners.splice(index, 1)
    }
  }
}
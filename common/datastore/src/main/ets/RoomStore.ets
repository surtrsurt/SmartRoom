// Room状态存储
// 查拉图斯特拉如是说

import { preferences } from '@kit.ArkData'

const ROOM_PREFERENCES_NAME = 'room_prefs'
const KEY_LIGHTS = 'lights'
const KEY_AIR_STATE = 'airState'
const KEY_CURTAINS = 'curtains'
const KEY_DISTURB_MODE = 'disturbMode'
const KEY_CLEAN_ROOM = 'cleanRoom'

export interface LightState {
  mainSwitch: boolean
  scene: number
  hardwareList: HardwareItem[]
}

export interface HardwareItem {
  id: number
  name: string
  on: boolean
}

export interface AirState {
  power: boolean
  mode: number
  temp: number
  speed: number
}

export interface CurtainState {
  leftCurtain: number
  rightCurtain: number
  leftSheer: number
  rightSheer: number
}

export class RoomStore {
  private static instance: RoomStore
  private prefs: preferences.Preferences | null = null

  private constructor() {}

  static getInstance(): RoomStore {
    if (!RoomStore.instance) {
      RoomStore.instance = new RoomStore()
    }
    return RoomStore.instance
  }

  async init(context: Context): Promise<void> {
    try {
      this.prefs = preferences.getPreferencesSync(context, {
        name: ROOM_PREFERENCES_NAME
      })
    } catch (error) {
      console.error('RoomStore init failed:', error)
    }
  }

  setLightState(state: LightState): void {
    if (this.prefs) {
      this.prefs.putSync(KEY_LIGHTS, JSON.stringify(state))
      this.prefs.flushSync()
    }
  }

  getLightState(): LightState | null {
    if (this.prefs) {
      const data = this.prefs.getSync(KEY_LIGHTS, '') as string
      if (data) {
        return JSON.parse(data) as LightState
      }
    }
    return null
  }

  setAirState(state: AirState): void {
    if (this.prefs) {
      this.prefs.putSync(KEY_AIR_STATE, JSON.stringify(state))
      this.prefs.flushSync()
    }
  }

  getAirState(): AirState | null {
    if (this.prefs) {
      const data = this.prefs.getSync(KEY_AIR_STATE, '') as string
      if (data) {
        return JSON.parse(data) as AirState
      }
    }
    return null
  }

  setCurtainState(state: CurtainState): void {
    if (this.prefs) {
      this.prefs.putSync(KEY_CURTAINS, JSON.stringify(state))
      this.prefs.flushSync()
    }
  }

  getCurtainState(): CurtainState | null {
    if (this.prefs) {
      const data = this.prefs.getSync(KEY_CURTAINS, '') as string
      if (data) {
        return JSON.parse(data) as CurtainState
      }
    }
    return null
  }

  setDisturbMode(enabled: boolean): void {
    if (this.prefs) {
      this.prefs.putSync(KEY_DISTURB_MODE, enabled)
      this.prefs.flushSync()
    }
  }

  getDisturbMode(): boolean {
    if (this.prefs) {
      return this.prefs.getSync(KEY_DISTURB_MODE, false) as boolean
    }
    return false
  }

  setCleanRoom(enabled: boolean): void {
    if (this.prefs) {
      this.prefs.putSync(KEY_CLEAN_ROOM, enabled)
      this.prefs.flushSync()
    }
  }

  getCleanRoom(): boolean {
    if (this.prefs) {
      return this.prefs.getSync(KEY_CLEAN_ROOM, false) as boolean
    }
    return false
  }

  clearAll(): void {
    if (this.prefs) {
      this.prefs.deleteSync(KEY_LIGHTS)
      this.prefs.deleteSync(KEY_AIR_STATE)
      this.prefs.deleteSync(KEY_CURTAINS)
      this.prefs.deleteSync(KEY_DISTURB_MODE)
      this.prefs.deleteSync(KEY_CLEAN_ROOM)
      this.prefs.flushSync()
    }
  }
}
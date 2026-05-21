import dataPreferences from '@ohos.data.preferences'

const PREFERENCES_NAME = 'smart_room_prefs'

export class PreferencesHelper {
  private static instance: PreferencesHelper | null = null
  private preferences: dataPreferences.Preferences | null = null

  private constructor() {}

  public static getInstance(): PreferencesHelper {
    if (PreferencesHelper.instance === null) {
      PreferencesHelper.instance = new PreferencesHelper()
    }
    return PreferencesHelper.instance
  }

  async init(context: Context): Promise<void> {
    try {
      this.preferences = dataPreferences.getPreferencesSync(context, {
        name: PREFERENCES_NAME
      })
    } catch (err) {
      console.error('PreferencesHelper init failed:', err)
    }
  }

  set(key: string, value: string | number | boolean): void {
    if (this.preferences) {
      this.preferences.putSync(key, value)
    }
  }

  get(key: string, defaultValue: string | number | boolean): string | number | boolean {
    if (this.preferences) {
      return this.preferences.getSync(key, defaultValue) as string | number | boolean
    }
    return defaultValue
  }

  delete(key: string): void {
    if (this.preferences) {
      this.preferences.deleteSync(key)
    }
  }

  clear(): void {
    if (this.preferences) {
      this.preferences.clearSync()
    }
  }

  async flush(): Promise<void> {
    if (this.preferences) {
      await this.preferences.flush()
    }
  }
}
// 空调ViewModel
// 查拉图斯特拉如是说

import { TokenStore } from 'common_datastore'
import { ToastUtils } from 'common_uicomponents'
import { AirRepository } from '../repository/AirRepository.ets'
import type { AirControlRequest } from 'common_mock'

export class AirViewModel {
  power: boolean = true
  mode: number = 0
  temp: number = 26
  speed: number = 1
  isLoading: boolean = false

  private repository: AirRepository = new AirRepository()
  private tokenStore: TokenStore = TokenStore.getInstance()

  async sendCommand(cmd: string, value?: number): Promise<void> {
    const token = this.tokenStore.getToken()
    const req: AirControlRequest = { cmd: cmd }
    if (value !== undefined) {
      req.value = value
    }

    try {
      const success = await this.repository.clickAirBtn(token, req)
      if (success) {
        this.applyCommand(cmd, value)
      } else {
        ToastUtils.show('操作失败')
      }
    } catch (error) {
      ToastUtils.show('网络请求失败')
    }
  }

  private applyCommand(cmd: string, value?: number): void {
    switch (cmd) {
      case 'power':
        if (value !== undefined) {
          this.power = value === 1
        }
        break
      case 'temp':
        if (value !== undefined) {
          this.temp = value
        }
        break
      case 'mode':
        if (value !== undefined) {
          this.mode = value
        }
        break
      case 'speed':
        if (value !== undefined) {
          this.speed = value
        }
        break
    }
  }

  async turnOn(): Promise<void> {
    await this.sendCommand('power', 1)
  }

  async turnOff(): Promise<void> {
    await this.sendCommand('power', 0)
  }

  async setTemp(temp: number): Promise<void> {
    await this.sendCommand('temp', temp)
  }

  async setMode(mode: number): Promise<void> {
    await this.sendCommand('mode', mode)
  }

  async setSpeed(speed: number): Promise<void> {
    await this.sendCommand('speed', speed)
  }
}
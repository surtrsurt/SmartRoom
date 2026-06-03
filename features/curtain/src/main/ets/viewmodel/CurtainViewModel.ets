// 窗帘ViewModel
// 查拉图斯特拉如是说

import { ToastUtils } from 'common_uicomponents'
import { CurtainRepository } from '../repository/CurtainRepository.ets'
import type { CurtainControlRequest } from 'common_mock'

export class CurtainViewModel {
  leftCurtain: number = 0
  rightCurtain: number = 0
  leftSheer: number = 0
  rightSheer: number = 0
  isCurtainPaused: boolean = false
  isSheerPaused: boolean = false
  isLoading: boolean = false

  private repository = new CurtainRepository()

  initState(): void {
    const state = this.repository.getInitialState()
    this.leftCurtain = state.leftCurtain
    this.rightCurtain = state.rightCurtain
    this.leftSheer = state.leftSheer
    this.rightSheer = state.rightSheer
  }

  async openCurtain(): Promise<void> {
    this.isLoading = true
    this.isCurtainPaused = false

    const req: CurtainControlRequest = { type: 'curtain', action: 'open' }
    await this.repository.controlCurtain(req)

    animateTo({
      duration: 500,
      curve: Curve.Linear
    }, () => {
      this.leftCurtain = 100
      this.rightCurtain = 100
    })

    this.isLoading = false
    ToastUtils.show('窗帘已打开')
  }

  async closeCurtain(): Promise<void> {
    this.isLoading = true
    this.isCurtainPaused = false

    const req: CurtainControlRequest = { type: 'curtain', action: 'close' }
    await this.repository.controlCurtain(req)

    animateTo({
      duration: 500,
      curve: Curve.Linear
    }, () => {
      this.leftCurtain = 0
      this.rightCurtain = 0
    })

    this.isLoading = false
    ToastUtils.show('窗帘已关闭')
  }

  async pauseCurtain(): Promise<void> {
    this.isCurtainPaused = true
    ToastUtils.show('窗帘已暂停')
  }

  async openSheer(): Promise<void> {
    this.isLoading = true
    this.isSheerPaused = false

    const req: CurtainControlRequest = { type: 'sheer', action: 'open' }
    await this.repository.controlCurtain(req)

    animateTo({
      duration: 500,
      curve: Curve.Linear
    }, () => {
      this.leftSheer = 100
      this.rightSheer = 100
    })

    this.isLoading = false
    ToastUtils.show('窗纱已打开')
  }

  async closeSheer(): Promise<void> {
    this.isLoading = true
    this.isSheerPaused = false

    const req: CurtainControlRequest = { type: 'sheer', action: 'close' }
    await this.repository.controlCurtain(req)

    animateTo({
      duration: 500,
      curve: Curve.Linear
    }, () => {
      this.leftSheer = 0
      this.rightSheer = 0
    })

    this.isLoading = false
    ToastUtils.show('窗纱已关闭')
  }

  async pauseSheer(): Promise<void> {
    this.isSheerPaused = true
    ToastUtils.show('窗纱已暂停')
  }
}
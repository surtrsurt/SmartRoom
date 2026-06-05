// 窗帘ViewModel
// 查拉图斯特拉如是说

import { hilog } from '@kit.PerformanceAnalysisKit'
import { ToastUtils } from 'common_uicomponents'
import { CurtainRepository } from '../repository/CurtainRepository.ets'
import type { CurtainControlRequest } from 'common_mock'

@ObservedV2
export class CurtainViewModel {
  // 布帘开合百分比 0.0=全关 1.0=全开
  @Trace clothPercent: number = 0
  // 窗纱开合百分比 0.0=全关 1.0=全开
  @Trace gauzePercent: number = 0

  // 布帘状态: closed / opening / paused / opened
  @Trace clothState: string = 'closed'
  // 窗纱状态: closed / opening / paused / opened
  @Trace gauzeState: string = 'closed'

  // 当前选中的控制按钮: 'none' / 'allOpen' / 'allClose' / 'cloth' / 'gauze'
  @Trace selectedControl: string = 'none'

  // 动画时长(ms)
  private animationDuration: number = 500
  // 动画步进间隔(ms)
  private animationStep: number = 16
  // 布帘动画定时器
  private clothAnimationTimer: number = -1
  // 窗纱动画定时器
  private gauzeAnimationTimer: number = -1

  private repository: CurtainRepository = new CurtainRepository()

  aboutToAppear(): void {
    this.initState()
  }

  initState(): void {
    const state = this.repository.getInitialState()
    this.clothPercent = state.leftCurtain > 0 || state.rightCurtain > 0 ? 1.0 : 0.0
    this.gauzePercent = state.leftSheer > 0 || state.rightSheer > 0 ? 1.0 : 0.0
    this.clothState = this.clothPercent === 1.0 ? 'opened' : 'closed'
    this.gauzeState = this.gauzePercent === 1.0 ? 'opened' : 'closed'
  }

  // 布帘打开
  openCloth(): void {
    if (this.clothState === 'paused') {
      this.clothState = 'opening'
      this.startClothAnimation(1.0)
      return
    }
    if (this.clothState === 'opening' || this.clothState === 'opened') {
      return
    }
    this.clothState = 'opening'
    this.selectedControl = 'cloth'
    this.startClothAnimation(1.0)
  }

  // 布帘关闭
  closeCloth(): void {
    if (this.clothState === 'paused') {
      this.clothState = 'closing'
      this.startClothAnimation(0.0)
      return
    }
    if (this.clothState === 'closing' || this.clothState === 'closed') {
      return
    }
    this.clothState = 'closing'
    this.selectedControl = 'cloth'
    this.startClothAnimation(0.0)
  }

  // 布帘暂停
  pauseCloth(): void {
    if (this.clothState === 'opening' || this.clothState === 'closing') {
      this.clothState = 'paused'
      ToastUtils.show('布帘已暂停')
    }
  }

  // 窗纱打开
  openGauze(): void {
    if (this.gauzeState === 'paused') {
      this.gauzeState = 'opening'
      this.startGauzeAnimation(1.0)
      return
    }
    if (this.gauzeState === 'opening' || this.gauzeState === 'opened') {
      return
    }
    this.gauzeState = 'opening'
    this.selectedControl = 'gauze'
    this.startGauzeAnimation(1.0)
  }

  // 窗纱关闭
  closeGauze(): void {
    if (this.gauzeState === 'paused') {
      this.gauzeState = 'closing'
      this.startGauzeAnimation(0.0)
      return
    }
    if (this.gauzeState === 'closing' || this.gauzeState === 'closed') {
      return
    }
    this.gauzeState = 'closing'
    this.selectedControl = 'gauze'
    this.startGauzeAnimation(0.0)
  }

  // 窗纱暂停
  pauseGauze(): void {
    if (this.gauzeState === 'opening' || this.gauzeState === 'closing') {
      this.gauzeState = 'paused'
      ToastUtils.show('窗纱已暂停')
    }
  }

  // 全部打开
  openAll(): void {
    this.selectedControl = 'allOpen'
    this.clothState = 'opening'
    this.gauzeState = 'opening'
    this.startClothAnimation(1.0)
    this.startGauzeAnimation(1.0)
  }

  // 全部关闭
  closeAll(): void {
    this.selectedControl = 'allClose'
    this.clothState = 'closing'
    this.gauzeState = 'closing'
    this.startClothAnimation(0.0)
    this.startGauzeAnimation(0.0)
  }

  // 启动布帘动画
  private startClothAnimation(targetPercent: number): void {
    if (this.clothAnimationTimer >= 0) {
      clearInterval(this.clothAnimationTimer)
      this.clothAnimationTimer = -1
    }

    const startPercent = this.clothPercent
    const step = (targetPercent - startPercent) / (this.animationDuration / this.animationStep)
    this.clothAnimationTimer = setInterval(() => {
      if (this.clothState === 'paused') {
        return
      }
      const current = this.clothPercent
      const newPercent = targetPercent > current ? Math.min(current + step, targetPercent) : Math.max(current + step, targetPercent)
      this.updateClothPercent(newPercent)
      if ((step > 0 && newPercent >= targetPercent) || (step < 0 && newPercent <= targetPercent)) {
        clearInterval(this.clothAnimationTimer)
        this.clothAnimationTimer = -1
        if (targetPercent === 1.0) {
          this.updateClothPercent(1.0)
          this.syncClothToStore()
        } else {
          this.updateClothPercent(0)
          this.syncClothClosedToStore()
        }
      }
    }, this.animationStep)
  }

  // 启动窗纱动画
  private startGauzeAnimation(targetPercent: number): void {
    if (this.gauzeAnimationTimer >= 0) {
      clearInterval(this.gauzeAnimationTimer)
      this.gauzeAnimationTimer = -1
    }

    const startPercent = this.gauzePercent
    const step = (targetPercent - startPercent) / (this.animationDuration / this.animationStep)
    this.gauzeAnimationTimer = setInterval(() => {
      if (this.gauzeState === 'paused') {
        return
      }
      const current = this.gauzePercent
      const newPercent = targetPercent > current ? Math.min(current + step, targetPercent) : Math.max(current + step, targetPercent)
      this.updateGauzePercent(newPercent)
      if ((step > 0 && newPercent >= targetPercent) || (step < 0 && newPercent <= targetPercent)) {
        clearInterval(this.gauzeAnimationTimer)
        this.gauzeAnimationTimer = -1
        if (targetPercent === 1.0) {
          this.updateGauzePercent(1.0)
          this.syncGauzeToStore()
        } else {
          this.updateGauzePercent(0)
          this.syncGauzeClosedToStore()
        }
      }
    }, this.animationStep)
  }

  // 更新布帘进度
  private updateClothPercent(percent: number): void {
    this.clothPercent = percent
    if (percent >= 1.0) {
      this.clothPercent = 1.0
      this.clothState = 'opened'
    } else if (percent <= 0) {
      this.clothPercent = 0
      this.clothState = 'closed'
    }
  }

  // 更新窗纱进度
  private updateGauzePercent(percent: number): void {
    this.gauzePercent = percent
    if (percent >= 1.0) {
      this.gauzePercent = 1.0
      this.gauzeState = 'opened'
    } else if (percent <= 0) {
      this.gauzePercent = 0
      this.gauzeState = 'closed'
    }
  }

  // 同步到Store
  private syncClothToStore(): void {
    const req: CurtainControlRequest = { type: 'curtain', action: 'open' }
    this.repository.controlCurtain(req)
    ToastUtils.show('布帘已打开')
  }

  private syncClothClosedToStore(): void {
    const req: CurtainControlRequest = { type: 'curtain', action: 'close' }
    this.repository.controlCurtain(req)
    ToastUtils.show('布帘已关闭')
  }

  private syncGauzeToStore(): void {
    const req: CurtainControlRequest = { type: 'sheer', action: 'open' }
    this.repository.controlCurtain(req)
    ToastUtils.show('窗纱已打开')
  }

  private syncGauzeClosedToStore(): void {
    const req: CurtainControlRequest = { type: 'sheer', action: 'close' }
    this.repository.controlCurtain(req)
    ToastUtils.show('窗纱已关闭')
  }
}
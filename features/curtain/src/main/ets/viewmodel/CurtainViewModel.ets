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

  // 最大位移像素
  private maxTranslate: number = 180

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

  // 获取布帘左边的 translateX（负值往左移）
  get clothLeftTranslate(): number {
    return -this.clothPercent * this.maxTranslate
  }

  // 获取布帘右边的 translateX（正值往右移）
  get clothRightTranslate(): number {
    return this.clothPercent * this.maxTranslate
  }

  // 获取窗纱左边的 translateX
  get gauzeLeftTranslate(): number {
    return -this.gauzePercent * this.maxTranslate
  }

  // 获取窗纱右边的 translateX
  get gauzeRightTranslate(): number {
    return this.gauzePercent * this.maxTranslate
  }

  // 是否全部打开（布帘和窗纱都打开）
  get isAllOpen(): boolean {
    return this.clothPercent === 1.0 && this.gauzePercent === 1.0
  }

  // 是否全部关闭（布帘和窗纱都关闭）
  get isAllClosed(): boolean {
    return this.clothPercent === 0.0 && this.gauzePercent === 0.0
  }

  // 布帘打开
  openCloth(): void {
    if (this.clothState === 'opening' || this.clothState === 'opened') {
      return // 已在打开中或已打开
    }
    this.clothState = 'opening'
    this.selectedControl = 'cloth'
  }

  // 布帘关闭
  closeCloth(): void {
    if (this.clothState === 'closing' || this.clothState === 'closed') {
      return // 已在关闭中或已关闭
    }
    this.clothState = 'closing'
    this.selectedControl = 'cloth'
  }

  // 布帘暂停
  pauseCloth(): void {
    if (this.clothState === 'opening' || this.clothState === 'closing') {
      this.clothState = 'paused'
      ToastUtils.show('布帘已暂停')
    }
  }

  // 更新布帘进度（动画中由UI调用）
  updateClothPercent(percent: number): void {
    this.clothPercent = percent
    if (percent >= 1.0) {
      this.clothPercent = 1.0
      this.clothState = 'opened'
    } else if (percent <= 0) {
      this.clothPercent = 0
      this.clothState = 'closed'
    }
  }

  // 窗纱打开
  openGauze(): void {
    if (this.gauzeState === 'opening' || this.gauzeState === 'opened') {
      return
    }
    this.gauzeState = 'opening'
    this.selectedControl = 'gauze'
  }

  // 窗纱关闭
  closeGauze(): void {
    if (this.gauzeState === 'closing' || this.gauzeState === 'closed') {
      return
    }
    this.gauzeState = 'closing'
    this.selectedControl = 'gauze'
  }

  // 窗纱暂停
  pauseGauze(): void {
    if (this.gauzeState === 'opening' || this.gauzeState === 'closing') {
      this.gauzeState = 'paused'
      ToastUtils.show('窗纱已暂停')
    }
  }

  // 更新窗纱进度
  updateGauzePercent(percent: number): void {
    this.gauzePercent = percent
    if (percent >= 1.0) {
      this.gauzePercent = 1.0
      this.gauzeState = 'opened'
    } else if (percent <= 0) {
      this.gauzePercent = 0
      this.gauzeState = 'closed'
    }
  }

  // 动画完成后的状态同步（供UI调用）
  syncClothToStore(): void {
    const req: CurtainControlRequest = { type: 'curtain', action: 'open' }
    this.repository.controlCurtain(req)
    ToastUtils.show('布帘已打开')
  }

  syncClothClosedToStore(): void {
    const req: CurtainControlRequest = { type: 'curtain', action: 'close' }
    this.repository.controlCurtain(req)
    ToastUtils.show('布帘已关闭')
  }

  syncGauzeToStore(): void {
    const req: CurtainControlRequest = { type: 'sheer', action: 'open' }
    this.repository.controlCurtain(req)
    ToastUtils.show('窗纱已打开')
  }

  syncGauzeClosedToStore(): void {
    const req: CurtainControlRequest = { type: 'sheer', action: 'close' }
    this.repository.controlCurtain(req)
    ToastUtils.show('窗纱已关闭')
  }

  async openAll(): Promise<void> {
    hilog.info(0x0000, 'CurtainViewModel', 'openAll')
    this.openCloth()
    this.openGauze()
    this.selectedControl = 'allOpen'
  }

  async closeAll(): Promise<void> {
    hilog.info(0x0000, 'CurtainViewModel', 'closeAll')
    this.closeCloth()
    this.closeGauze()
    this.selectedControl = 'allClose'
  }
}

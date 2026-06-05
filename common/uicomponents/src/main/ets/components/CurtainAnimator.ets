// 窗帘动画控制器
// 查拉图斯特拉如是说

export type CurtainState = 'opening' | 'closing' | 'opened' | 'closed' | 'paused'

export interface CurtainAnimatorCallback {
  onPercentChange: (percent: number) => void
  onStateChange: (state: CurtainState) => void
}

export class CurtainAnimator {
  private animationDuration: number = 500
  private animationStep: number = 16
  private timerId: number = -1
  private targetPercent: number = 0
  private currentPercent: number = 0
  private currentState: CurtainState = 'closed'
  private callback: CurtainAnimatorCallback | null = null

  setCallback(cb: CurtainAnimatorCallback): void {
    this.callback = cb
  }

  startAnimation(targetPercent: number, state: CurtainState, currentPercent: number): void {
    this.stop()
    this.targetPercent = targetPercent
    this.currentPercent = currentPercent
    this.currentState = state

    const step = (targetPercent - currentPercent) / (this.animationDuration / this.animationStep)
    this.timerId = setInterval(() => {
      if (this.callback) {
        const newPercent = targetPercent > currentPercent ?
          Math.min(this.currentPercent + step, targetPercent) :
          Math.max(this.currentPercent + step, targetPercent)

        this.currentPercent = newPercent
        this.callback.onPercentChange(newPercent)

        if ((step > 0 && newPercent >= targetPercent) || (step < 0 && newPercent <= targetPercent)) {
          this.stop()
          this.currentPercent = targetPercent === 1.0 ? 1.0 : 0
          this.currentState = targetPercent === 1.0 ? 'opened' : 'closed'
          this.callback.onStateChange(this.currentState)
        }
      }
    }, this.animationStep)
  }

  pause(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId)
      this.timerId = -1
      this.currentState = 'paused'
      this.callback?.onStateChange('paused')
    }
  }

  stop(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId)
      this.timerId = -1
    }
  }

  getState(): CurtainState {
    return this.currentState
  }

  getPercent(): number {
    return this.currentPercent
  }
}

// 单例管理
let clothAnimator: CurtainAnimator | null = null
let gauzeAnimator: CurtainAnimator | null = null

export function getClothAnimator(): CurtainAnimator {
  if (!clothAnimator) {
    clothAnimator = new CurtainAnimator()
  }
  return clothAnimator
}

export function getGauzeAnimator(): CurtainAnimator {
  if (!gauzeAnimator) {
    gauzeAnimator = new CurtainAnimator()
  }
  return gauzeAnimator
}
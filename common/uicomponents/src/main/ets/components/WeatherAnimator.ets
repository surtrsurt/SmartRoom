// 天气动画控制器
// 查拉图斯特拉如是说

// RainDrop类型 - 避免导入common_weather
export interface RainDrop {
  id: number
  x: number
  y: number
  speed: number
  length: number
}

export type WeatherConditionType = 'sunny' | 'cloudy' | 'rainy' | 'snowy' | 'foggy' | 'unknown'

export class WeatherAnimator {
  private cloudOffset: number = 0
  private rainDrops: RainDrop[] = []
  private snowDrops: RainDrop[] = []

  // 定时器ID
  private cloudTimer: number = -1
  private rainTimer: number = -1
  private snowTimer: number = -1
  private rainMoveTimer: number = -1
  private snowMoveTimer: number = -1

  // 回调函数
  private onCloudOffsetChange: ((offset: number) => void) | null = null
  private onRainDropsChange: ((drops: RainDrop[]) => void) | null = null
  private onSnowDropsChange: ((drops: RainDrop[]) => void) | null = null

  setCallbacks(
    onCloud: (offset: number) => void,
    onRain: (drops: RainDrop[]) => void,
    onSnow: (drops: RainDrop[]) => void
  ): void {
    this.onCloudOffsetChange = onCloud
    this.onRainDropsChange = onRain
    this.onSnowDropsChange = onSnow
  }

  startWeatherAnimation(condition: WeatherConditionType): void {
    this.stopAll()

    // 云朵动画
    this.cloudTimer = setInterval(() => {
      this.cloudOffset += 2
      if (this.cloudOffset > 350) {
        this.cloudOffset = -150
      }
      this.onCloudOffsetChange?.(this.cloudOffset)
    }, 50)

    // 雨滴生成
    this.rainTimer = setInterval(() => {
      if (condition === 'rainy') {
        let drop: RainDrop = {
          id: Date.now() + Math.random(),
          x: Math.random() * 280 + 10,
          y: 0,
          speed: Math.random() * 5 + 3,
          length: Math.random() * 15 + 10
        }
        this.rainDrops.push(drop)
        if (this.rainDrops.length > 30) {
          this.rainDrops.shift()
        }
        this.onRainDropsChange?.([...this.rainDrops])
      }
    }, 100)

    // 雨滴移动
    this.rainMoveTimer = setInterval(() => {
      if (condition === 'rainy') {
        let updated: RainDrop[] = []
        for (let i = 0; i < this.rainDrops.length; i++) {
          let d = this.rainDrops[i]
          let newY: number = d.y + d.speed
          if (newY < 200) {
            updated.push({
              id: d.id,
              x: d.x,
              y: newY,
              speed: d.speed,
              length: d.length
            })
          }
        }
        this.rainDrops = updated
        this.onRainDropsChange?.([...this.rainDrops])
      } else {
        this.rainDrops = []
        this.onRainDropsChange?.([])
      }
    }, 50)

    // 雪花生成
    this.snowTimer = setInterval(() => {
      if (condition === 'snowy') {
        let drop: RainDrop = {
          id: Date.now() + Math.random(),
          x: Math.random() * 280 + 10,
          y: 0,
          speed: Math.random() * 2 + 1,
          length: Math.random() * 4 + 3
        }
        this.snowDrops.push(drop)
        if (this.snowDrops.length > 40) {
          this.snowDrops.shift()
        }
        this.onSnowDropsChange?.([...this.snowDrops])
      }
    }, 150)

    // 雪花移动
    this.snowMoveTimer = setInterval(() => {
      if (condition === 'snowy') {
        let updated: RainDrop[] = []
        for (let i = 0; i < this.snowDrops.length; i++) {
          let d = this.snowDrops[i]
          let newY: number = d.y + d.speed
          let newX: number = d.x + Math.sin(newY * 0.05) * 0.5
          if (newY < 200) {
            updated.push({
              id: d.id,
              x: newX,
              y: newY,
              speed: d.speed,
              length: d.length
            })
          }
        }
        this.snowDrops = updated
        this.onSnowDropsChange?.([...this.snowDrops])
      } else {
        this.snowDrops = []
        this.onSnowDropsChange?.([])
      }
    }, 50)
  }

  stopAll(): void {
    if (this.cloudTimer !== -1) {
      clearInterval(this.cloudTimer)
      this.cloudTimer = -1
    }
    if (this.rainTimer !== -1) {
      clearInterval(this.rainTimer)
      this.rainTimer = -1
    }
    if (this.rainMoveTimer !== -1) {
      clearInterval(this.rainMoveTimer)
      this.rainMoveTimer = -1
    }
    if (this.snowTimer !== -1) {
      clearInterval(this.snowTimer)
      this.snowTimer = -1
    }
    if (this.snowMoveTimer !== -1) {
      clearInterval(this.snowMoveTimer)
      this.snowMoveTimer = -1
    }
  }

  updateCondition(condition: WeatherConditionType): void {
    this.startWeatherAnimation(condition)
  }

  getCloudOffset(): number {
    return this.cloudOffset
  }

  getRainDrops(): RainDrop[] {
    return this.rainDrops
  }

  getSnowDrops(): RainDrop[] {
    return this.snowDrops
  }
}

// 单例
let animatorInstance: WeatherAnimator | null = null

export function getWeatherAnimator(): WeatherAnimator {
  if (!animatorInstance) {
    animatorInstance = new WeatherAnimator()
  }
  return animatorInstance
}
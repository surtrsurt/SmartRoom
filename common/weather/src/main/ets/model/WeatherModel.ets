// 天气数据模型
export type WeatherCondition = 'sunny' | 'cloudy' | 'rainy' | 'snowy' | 'foggy'

export interface WeatherData {
  city: string
  temperature: number
  condition: WeatherCondition
  humidity: number
  windDirection: string
  windPower: string
}

export interface CityInfo {
  name: string
  adcode: string
  distance?: number
}

// 天气提示语
export interface WeatherTip {
  condition: WeatherCondition
  tip: string
  color: string
}

// 雨滴/雪花粒子
export interface RainDrop {
  id: number
  x: number
  y: number
  speed: number
  length: number
}

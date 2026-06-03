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

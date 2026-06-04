// 服务模型
// 查拉图斯特拉如是说

import type { WeatherCondition } from 'common_weather'

export interface ServiceControlRequest {
  type: 'disturb' | 'clean' | 'sos' | 'checkout'
}

export enum ServiceType {
  DISTURB = 'disturb',
  CLEAN = 'clean',
  SOS = 'sos',
  CHECKOUT = 'checkout'
}

// ============ 天气相关类型和函数 ============

// 雨滴/雪花粒子
export interface WeatherParticle {
  id: number
  x: number
  y: number
  speed: number
  length: number
}

// 天气提示语
export interface WeatherTip {
  condition: WeatherCondition
  tip: string
  color: string
}

// 对话框按钮
export interface DialogButton {
  text: string
  color: string
}

// 天气提示语映射
export const WEATHER_TIPS: WeatherTip[] = [
  { condition: 'sunny', tip: '阳光明媚，适宜户外活动', color: '#FFD700' },
  { condition: 'cloudy', tip: '多云天气，记得防晒', color: '#B0C4DE' },
  { condition: 'rainy', tip: '雨天路滑，请注意出行安全', color: '#6EA8FF' },
  { condition: 'snowy', tip: '雪天路滑，请小心慢行', color: '#E0FFFF' },
  { condition: 'foggy', tip: '雾天能见度低，请注意安全', color: '#D3D3D3' }
]

// 获取天气文字描述
export function getConditionText(condition: WeatherCondition): string {
  switch (condition) {
    case 'sunny': return '晴'
    case 'cloudy': return '多云'
    case 'rainy': return '雨'
    case 'snowy': return '雪'
    case 'foggy': return '雾'
    default: return '多云'
  }
}

// 获取温馨提示
export function getWeatherTip(weather: WeatherCondition | null): WeatherTip {
  if (!weather) return WEATHER_TIPS[1]
  const tip = WEATHER_TIPS.find(t => t.condition === weather)
  return tip || WEATHER_TIPS[1]
}
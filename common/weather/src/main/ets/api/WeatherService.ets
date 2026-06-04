import { http } from '@kit.NetworkKit'
import type { WeatherData, CityInfo, WeatherCondition } from '../model/WeatherModel'
import { getCitiesByDistance } from '../util/CitySearchUtil'

const BASE_URL = 'https://restapi.amap.com/v3'
const KEY = 'f4a1aae3261c2d264389db2cda9e5d1f'

export class WeatherService {
  private static instance: WeatherService

  static getInstance(): WeatherService {
    if (!WeatherService.instance) {
      WeatherService.instance = new WeatherService()
    }
    return WeatherService.instance
  }

  async fetchWeather(adcode: string): Promise<WeatherData | null> {
    const url = `${BASE_URL}/weather/weatherInfo?key=${KEY}&city=${adcode}&extensions=base`

    try {
      const request = http.createHttp()
      const resp = await request.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 5000,
        readTimeout: 5000
      })

      if (resp.result) {
        const data = JSON.parse(resp.result as string) as AmapResponse
        console.info(`Weather API response: ${JSON.stringify(data)}`)
        if (data.status === '1' && data.lives && data.lives.length > 0) {
          const live = data.lives[0]
          return {
            city: live.province + live.city,
            temperature: parseInt(live.temperature),
            condition: this.parseCondition(live.weather),
            humidity: parseInt(live.humidity),
            windDirection: live.winddirection,
            windPower: live.windpower
          }
        }
      }
      return null
    } catch (err) {
      console.error(`Weather fetch error: ${err}`)
      return null
    }
  }

  private parseCondition(weather: string): WeatherCondition {
    if (weather.includes('雪')) return 'snowy'
    if (weather.includes('雨')) return 'rainy'
    if (weather.includes('雾') || weather.includes('霾')) return 'foggy'
    if (weather.includes('多云')) return 'cloudy'
    return 'sunny'
  }

  // 获取城市列表（按距离东莞排序）
  getCitiesByDistance(): CityInfo[] {
    return getCitiesByDistance()
  }
}

interface AmapResponse {
  status: string
  lives?: AmapLive[]
}

interface AmapLive {
  province: string
  city: string
  weather: string
  temperature: string
  humidity: string
  feels_like: string
  winddirection: string
  windpower: string
}
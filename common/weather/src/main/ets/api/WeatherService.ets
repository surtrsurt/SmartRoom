import { http } from '@kit.NetworkKit'
import { WeatherData, CityInfo, WeatherCondition } from './ApiResponse'
import { PRESET_CITIES, DONGGUAN_LNG, DONGGUAN_LAT } from '../util/CityData'

const BASE_URL = 'https://restapi.amap.com/v3'
const KEY = 'f4a1aae3261c2d264389db2cda9e5d1f'

// 计算两点之间的距离（km）
function calculateDistance(lng1: number, lat1: number, lng2: number, lat2: number): number {
  const R = 6371 // 地球半径，单位km
  const dLat = (lat2 - lat1) * Math.PI / 180
  const dLon = (lng2 - lng1) * Math.PI / 180
  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2)
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  return R * c
}

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
    // 计算每个城市到东莞的距离并排序
    const sortedCities: CityDistanceInfo[] = PRESET_CITIES.map(city => {
      const dist = calculateDistance(city.lng, city.lat, DONGGUAN_LNG, DONGGUAN_LAT)
      return {
        cityName: city.name,
        adcode: city.adcode,
        distance: Math.round(dist)
      } as CityDistanceInfo
    })

    // 按距离排序
    sortedCities.sort((a, b) => a.distance - b.distance)

    // 返回排序后的城市信息
    const result: CityInfo[] = sortedCities.map(item => {
      const cityInfo: CityInfo = {
        name: item.cityName,
        adcode: item.adcode,
        distance: item.distance
      }
      return cityInfo
    })
    return result
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

interface CityDistanceInfo {
  cityName: string
  adcode: string
  distance: number
}

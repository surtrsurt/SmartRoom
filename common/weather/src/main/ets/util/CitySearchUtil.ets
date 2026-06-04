// 城市搜索工具
// 查拉图斯特拉如是说

import type { CityInfo } from '../model/WeatherModel'
import { PRESET_CITIES, DONGGUAN_LNG, DONGGUAN_LAT } from '../util/CityData'

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

// 获取所有城市列表（按距离东莞排序）
function getAllCitiesSorted(): CityInfo[] {
  const sortedCities = PRESET_CITIES.map(city => {
    const dist = calculateDistance(city.lng, city.lat, DONGGUAN_LNG, DONGGUAN_LAT)
    return {
      name: city.name,
      adcode: city.adcode,
      distance: Math.round(dist)
    } as CityInfo
  })
  sortedCities.sort((a, b) => (a.distance ?? 0) - (b.distance ?? 0))
  return sortedCities
}

// 搜索城市（模糊匹配城市名）
export function searchCities(keyword: string): CityInfo[] {
  const allCities = getAllCitiesSorted()
  if (!keyword || keyword.trim().length === 0) {
    return allCities.slice(0, 10) // 默认返回前10个最近城市
  }
  const lowerKeyword = keyword.toLowerCase().trim()
  return allCities.filter(city =>
    city.name.toLowerCase().includes(lowerKeyword)
  ).slice(0, 20) // 最多返回20个匹配结果
}

// 获取城市列表（按距离东莞排序）
export function getCitiesByDistance(): CityInfo[] {
  return getAllCitiesSorted()
}
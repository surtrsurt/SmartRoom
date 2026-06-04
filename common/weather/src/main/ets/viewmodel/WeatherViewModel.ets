// 天气ViewModel - 城市搜索逻辑
// 查拉图斯特拉如是说

import type { CityInfo } from '../model/WeatherModel'
import { getCitiesByDistance, searchCities } from '../util/CitySearchUtil'

@ObservedV2
export class WeatherViewModel {
  @Trace citySearchText: string = ''
  @Trace searchResults: CityInfo[] = []
  @Trace selectedCityIndex: number = 0

  // 城市列表（按距离东莞排序）
  private cities: CityInfo[] = []

  constructor() {
    this.cities = getCitiesByDistance()
  }

  // 获取城市列表（按距离东莞排序）
  getCitiesByDistance(): CityInfo[] {
    return this.cities
  }

  // 更新城市搜索结果
  updateCitySearch(keyword: string): void {
    this.citySearchText = keyword
    if (keyword.trim().length === 0) {
      this.searchResults = []
    } else {
      this.searchResults = searchCities(keyword)
    }
  }

  // 应用第一个搜索结果
  applyFirstResult(): boolean {
    if (this.searchResults.length > 0) {
      const city = this.searchResults[0]
      const index = this.cities.findIndex(c => c.adcode === city.adcode)
      if (index !== -1) {
        this.selectedCityIndex = index
        this.citySearchText = ''
        this.searchResults = []
        return true
      }
    }
    return false
  }

  // 根据adcode查找城市在列表中的索引
  getCityIndexByAdcode(adcode: string): number {
    return this.cities.findIndex(c => c.adcode === adcode)
  }

  // 选择城市
  selectCity(index: number): void {
    this.selectedCityIndex = index
    this.citySearchText = ''
    this.searchResults = []
  }

  // 清除搜索
  clearSearch(): void {
    this.citySearchText = ''
    this.searchResults = []
  }
}
// 天气ViewModel - ServicePage天气卡片专用
// 查拉图斯特拉如是说

import { WeatherService, getCitiesByDistance, type WeatherData, type CityInfo } from 'common_weather'
import { WeatherAnimator, getWeatherAnimator, RainDrop, type WeatherConditionType } from 'common_uicomponents'

@ObservedV2
export class ServiceWeatherViewModel {
  // 城市列表（按距离东莞排序）
  cities: CityInfo[] = getCitiesByDistance()

  // 天气数据
  @Trace currentWeather: WeatherData | null = null
  @Trace isLoadingWeather: boolean = true

  // 动画相关
  @Trace cloudOffset: number = 0
  @Trace rainDrops: RainDrop[] = []
  @Trace snowDrops: RainDrop[] = []

  // 城市搜索
  @Trace selectedCityIndex: number = 0
  @Trace citySearchText: string = ''
  @Trace searchResults: CityInfo[] = []

  private weatherAnimator: WeatherAnimator = getWeatherAnimator()

  // 获取当前城市
  get currentCity(): CityInfo {
    return this.cities[this.selectedCityIndex] || this.cities[0]
  }

  // 获取天气文字描述
  getConditionText(condition: WeatherConditionType): string {
    switch (condition) {
      case 'sunny': return '晴'
      case 'cloudy': return '多云'
      case 'rainy': return '雨'
      case 'snowy': return '雪'
      case 'foggy': return '雾'
      default: return '多云'
    }
  }

  // 加载天气数据
  async loadWeather(): Promise<void> {
    this.isLoadingWeather = true
    const weatherService = WeatherService.getInstance()
    const adcode = this.currentCity.adcode

    try {
      const weather = await weatherService.fetchWeather(adcode)
      if (weather) {
        this.currentWeather = weather as WeatherData
        this.weatherAnimator.updateCondition(this.currentWeather.condition)
      } else {
        this.currentWeather = {
          city: this.currentCity.name,
          temperature: 0,
          condition: 'cloudy',
          humidity: 50,
          windDirection: '',
          windPower: ''
        }
        this.weatherAnimator.updateCondition('cloudy')
      }
    } catch (err) {
      console.error(`加载天气失败: ${err}`)
    } finally {
      this.isLoadingWeather = false
    }
  }

  // 设置动画回调
  setAnimatorCallbacks(): void {
    this.weatherAnimator.setCallbacks(
      (offset: number) => { this.cloudOffset = offset },
      (drops: RainDrop[]) => { this.rainDrops = drops },
      (drops: RainDrop[]) => { this.snowDrops = drops }
    )
  }

  // 停止动画
  stopAnimator(): void {
    this.weatherAnimator.stopAll()
  }

  // 城市搜索
  updateCitySearch(text: string): void {
    this.citySearchText = text
    if (text.length > 0) {
      this.searchResults = this.cities.filter(city =>
        city.name.includes(text)
      )
    } else {
      this.searchResults = []
    }
  }

  // 选择城市
  selectCity(index: number): void {
    this.selectedCityIndex = index
    this.citySearchText = ''
    this.searchResults = []
  }

  // 根据adcode获取城市索引
  getCityIndexByAdcode(adcode: string): number {
    return this.cities.findIndex(c => c.adcode === adcode)
  }

  // 应用第一个搜索结果
  applyFirstResult(): void {
    if (this.searchResults.length > 0) {
      this.selectCity(this.getCityIndexByAdcode(this.searchResults[0].adcode))
    }
  }
}
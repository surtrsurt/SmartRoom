// 服务页面
// 查拉图斯特拉如是说

import { ToastUtils, TitleSection, ServiceSwitchCard, ServiceSosCard, ServiceLogoutCard } from 'common_uicomponents'
import { ServiceWeatherCard } from '../components'
import { ServiceControlViewModel } from '../viewmodel/ServiceControlViewModel.ets'
import { ServiceWeatherViewModel } from '../viewmodel/ServiceWeatherViewModel.ets'
import { WEATHER_TIPS } from '../model/ServiceModel.ets'
import type { WeatherTip, CityInfo } from 'common_weather'
import type { NavPathStackInterface } from 'common_datastore'

@ComponentV2
export struct ServicePage {
  @Param pathStack: NavPathStackInterface | undefined = undefined
  @Local serviceVM: ServiceControlViewModel = new ServiceControlViewModel()
  @Local weatherVM: ServiceWeatherViewModel = new ServiceWeatherViewModel()
  @Local isSosCalling: boolean = false

  aboutToAppear(): void {
    this.serviceVM.aboutToAppear()
    this.serviceVM.pathStack = this.pathStack
    this.weatherVM.setAnimatorCallbacks()
    this.weatherVM.loadWeather()
  }

  aboutToDisappear(): void {
    this.weatherVM.stopAnimator()
  }

  private handleSosClick(): void {
    if (this.isSosCalling) {
      return
    }
    this.isSosCalling = true
    ToastUtils.show('正在呼叫前台...')

    setTimeout(() => {
      ToastUtils.show('已呼叫前台，请稍候', 3000)
    }, 2000)

    setTimeout(() => {
      this.isSosCalling = false
    }, 5000)
  }

  private getWeatherTipInfo(): WeatherTip {
    if (!this.weatherVM.currentWeather) return WEATHER_TIPS[1]
    const tip = WEATHER_TIPS.find(t => t.condition === this.weatherVM.currentWeather!.condition)
    return tip || WEATHER_TIPS[1]
  }

  build() {
    Stack() {
      Image($r('app.media.service_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,8,25,0.45)')

      Scroll() {
        Column({ space: 22 }) {
          TitleSection({ title: '服务控制' })
          ServiceSwitchCard({
            disturbMode: this.serviceVM.disturbMode,
            cleanRoom: this.serviceVM.cleanRoom,
            onToggleDisturb: () => this.serviceVM.toggleDisturbMode(),
            onToggleClean: () => this.serviceVM.toggleCleanRoom()
          })
          ServiceSosCard({ isCalling: this.isSosCalling, onTap: () => this.handleSosClick() })
          ServiceWeatherCard({
            currentWeather: this.weatherVM.currentWeather,
            currentCity: this.weatherVM.currentCity,
            citySearchText: this.weatherVM.citySearchText,
            searchResults: this.weatherVM.searchResults,
            selectedCityIndex: this.weatherVM.selectedCityIndex,
            cloudOffset: this.weatherVM.cloudOffset,
            rainDrops: this.weatherVM.rainDrops,
            snowDrops: this.weatherVM.snowDrops,
            weatherTip: this.getWeatherTipInfo(),
            conditionText: this.weatherVM.currentWeather ? this.weatherVM.getConditionText(this.weatherVM.currentWeather.condition) : '多云',
            onSearchChange: (text: string) => this.weatherVM.updateCitySearch(text),
            onSearchSubmit: () => {
              this.weatherVM.applyFirstResult()
              this.weatherVM.loadWeather()
            },
            onCitySelect: (city: CityInfo) => {
              this.weatherVM.selectCity(this.weatherVM.getCityIndexByAdcode(city.adcode))
              this.weatherVM.loadWeather()
            },
            getCityIndexByAdcode: (adcode: string) => this.weatherVM.getCityIndexByAdcode(adcode)
          })
          ServiceLogoutCard({ onTap: () => this.serviceVM.logout() })
          Blank().height(120)
        }
        .padding({ left: 24, right: 24, bottom: 24 })
      }
      .scrollBar(BarState.On)
    }
    .width('100%')
    .height('100%')
    .clip(true)
  }
}
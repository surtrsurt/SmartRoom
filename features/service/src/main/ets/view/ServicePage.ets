// 服务页面
// 查拉图斯特拉如是说

import { promptAction } from '@kit.ArkUI'
import { ToastUtils, ServiceToggleCard, TitleSection, RainDrop } from 'common_uicomponents'
import { TokenStore } from 'common_datastore'
import { ServiceControlViewModel } from '../viewmodel/ServiceControlViewModel.ets'
import { ServiceWeatherViewModel } from '../viewmodel/ServiceWeatherViewModel.ets'
import { WEATHER_TIPS } from '../model/ServiceModel.ets'
import type { WeatherData, CityInfo, WeatherTip } from 'common_weather'
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

  private async logout(): Promise<void> {
    const action = await promptAction.showDialog({
      title: '退出登录',
      message: '确定要退出登录吗？',
      buttons: [
        { text: '取消', color: '#666666' },
        { text: '确定', color: '#E8C27F' }
      ]
    })

    if (action.index === 1) {
      AppStorage.setOrCreate('token', '')
      AppStorage.setOrCreate('loginTime', 0)
      AppStorage.setOrCreate('isLogin', false)
      AppStorage.setOrCreate('firstName', '')

      const tokenStore = TokenStore.getInstance()
      tokenStore.clearToken()

      ToastUtils.show('已退出登录')

      if (this.pathStack) {
        this.pathStack.clear()
        this.pathStack.pushPathByName('login', null)
      }
    }
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
          this.ServiceSwitchArea()
          this.SosCard()
          this.WeatherCard()
          this.LogoutCard()
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

  @Builder
  private ServiceSwitchArea() {
    Row({ space: 18 }) {
      ServiceToggleCard({
        icon: $r('app.media.service_icon_do_not_disturb'),
        title: '请勿打扰',
        isOn: this.serviceVM.disturbMode,
        onToggleHandler: () => this.serviceVM.toggleDisturbMode()
      })

      ServiceToggleCard({
        icon: $r('app.media.service_icon_clean_room'),
        title: '清理房间',
        isOn: this.serviceVM.cleanRoom,
        onToggleHandler: () => this.serviceVM.toggleCleanRoom()
      })
    }
  }

  @Builder
  private SosCard() {
    Row() {
      Row() {
        Image($r('app.media.service_icon_sos'))
          .width(120)
          .height(120)
      }
      .width(120)
      .height(120)
      .backgroundColor(this.isSosCalling ? 'rgba(255,50,50,0.25)' : 'rgba(255,0,0,0.12)')
      .borderRadius(60)

      Column() {
        Text('SOS 紧急呼叫')
          .fontSize(34)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.isSosCalling ? '#FF6B6B' : '#F4D39A')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 20 })
    }
    .width('100%')
    .height(140)
    .padding(20)
    .backgroundColor(this.isSosCalling ? 'rgba(255,50,50,0.25)' : 'rgba(0,30,80,0.92)')
    .borderRadius(24)
    .border({ width: 1, color: this.isSosCalling ? '#FF4444' : '#6EA8FF' })
    .shadow({
      radius: 25,
      color: this.isSosCalling ? 'rgba(255,80,80,0.4)' : 'rgba(80,120,255,0.25)'
    })
    .onClick(() => this.handleSosClick())
  }

  @Builder
  private WeatherCard() {
    Stack() {
      // 背景层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(10,28,65,0.88)')
        .borderRadius(24)

      // 太阳图标（晴天显示）
      if (this.weatherVM.currentWeather && this.weatherVM.currentWeather.condition === 'sunny') {
        Image($r('app.media.service_sun'))
          .width(100)
          .height(100)
          .position({ x: '68%', y: 15 })
      }

      // 云朵动画（仅多云显示）
      if (this.weatherVM.currentWeather && this.weatherVM.currentWeather.condition === 'cloudy') {
        Row() {
          Circle().width(40).height(40).fill('#FFFFFF').opacity(0.6)
          Circle().width(50).height(50).fill('#FFFFFF').opacity(0.7)
          Circle().width(35).height(35).fill('#FFFFFF').opacity(0.6)
        }
        .translate({ x: this.weatherVM.cloudOffset, y: 20 })
      }

      // 雨滴动画（雨天显示）
      if (this.weatherVM.currentWeather && this.weatherVM.currentWeather.condition === 'rainy') {
        ForEach(this.weatherVM.rainDrops, (drop: RainDrop) => {
          Column()
            .width(2)
            .height(drop.length)
            .backgroundColor('#FFFFFF')
            .opacity(0.5)
            .borderRadius(1)
            .translate({ x: drop.x, y: drop.y })
        })
      }

      // 雪花动画（雪天显示）
      if (this.weatherVM.currentWeather && this.weatherVM.currentWeather.condition === 'snowy') {
        ForEach(this.weatherVM.snowDrops, (drop: RainDrop) => {
          Circle()
            .width(drop.length)
            .height(drop.length)
            .fill('#FFFFFF')
            .opacity(0.8)
            .translate({ x: drop.x, y: drop.y })
        })
      }

      // 天气信息层
      Column() {
        this.CitySearchInput()
        this.SearchResultsList()
        this.WeatherInfo()
      }
      .width('100%')
      .padding(20)
    }
    .width('100%')
    .height(260)
  }

  @Builder
  private CitySearchInput() {
    Row() {
      TextInput({ placeholder: '输入城市名搜索', text: this.weatherVM.citySearchText })
        .width('100%')
        .height(44)
        .fontSize(16)
        .fontColor('#FFFFFF')
        .placeholderColor('rgba(255,255,255,0.5)')
        .backgroundColor('rgba(255,255,255,0.15)')
        .borderRadius(8)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          this.weatherVM.updateCitySearch(value)
        })
        .onSubmit(() => {
          this.weatherVM.applyFirstResult()
          this.weatherVM.loadWeather()
        })
    }
    .width('100%')
    .margin({ bottom: 8 })
  }

  @Builder
  private SearchResultsList() {
    if (this.weatherVM.searchResults.length > 0 && this.weatherVM.citySearchText.length > 0) {
      Column() {
        Scroll() {
          Column() {
            ForEach(this.weatherVM.searchResults, (city: CityInfo) => {
              Text(city.name + (city.distance !== undefined ? ` (${city.distance}km)` : ''))
                .fontSize(14)
                .fontColor(this.weatherVM.selectedCityIndex === this.weatherVM.getCityIndexByAdcode(city.adcode) ? '#E8C27F' : '#FFFFFF')
                .width('100%')
                .padding({ top: 8, bottom: 8 })
                .onClick(() => {
                  this.weatherVM.selectCity(this.weatherVM.getCityIndexByAdcode(city.adcode))
                  this.weatherVM.loadWeather()
                })
            })
          }
          .padding(8)
        }
        .width('100%')
        .height(120)
        .backgroundColor('rgba(0,30,80,0.95)')
        .borderRadius(8)
      }
      .width('100%')
      .margin({ bottom: 8 })
    }
  }

  @Builder
  private WeatherInfo() {
    Column() {
      // 城市名称
      Text(this.weatherVM.currentCity.name)
        .fontSize(16)
        .fontColor('rgba(255,255,255,0.8)')
        .margin({ bottom: 4 })

      // 温度和天气信息
      Row() {
        Column() {
          if (this.weatherVM.currentWeather) {
            Text(this.weatherVM.currentWeather.temperature.toString())
              .fontSize(72)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
            Text(this.weatherVM.getConditionText(this.weatherVM.currentWeather.condition))
              .fontSize(24)
              .fontColor('#FFFFFF')
          } else {
            Text('--')
              .fontSize(72)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
            Text('加载中')
              .fontSize(24)
              .fontColor('#FFFFFF')
          }
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        Column() {
          if (this.weatherVM.currentWeather) {
            Text('湿度 ' + this.weatherVM.currentWeather.humidity + '%')
              .fontSize(14)
              .fontColor('rgba(255,255,255,0.85)')
            Text(this.weatherVM.currentWeather.windDirection + ' ' + this.weatherVM.currentWeather.windPower)
              .fontSize(14)
              .fontColor('rgba(255,255,255,0.85)')
              .margin({ top: 6 })
          } else {
            Text('湿度 --%')
              .fontSize(14)
              .fontColor('rgba(255,255,255,0.85)')
            Text('-- --')
              .fontSize(14)
              .fontColor('rgba(255,255,255,0.85)')
              .margin({ top: 6 })
          }
        }
        .alignItems(HorizontalAlign.End)
      }
      .margin({ top: 15 })

      // 温馨提示
      Text(this.getWeatherTipInfo().tip)
        .fontSize(14)
        .fontColor(this.getWeatherTipInfo().color)
        .margin({ top: 10 })
    }
  }

  @Builder
  private LogoutCard() {
    Row() {
      Image($r('app.media.service_icon_log_out'))
        .width(100)
        .height(100)

      Text('退出登录')
        .fontSize(34)
        .fontWeight(FontWeight.Medium)
        .fontColor('#E8C27F')
        .margin({ left: 20 })

      Blank()
    }
    .width('100%')
    .height(120)
    .padding({ left: 24, right: 24 })
    .backgroundColor('rgba(10,28,65,0.88)')
    .borderRadius(24)
    .border({ width: 1, color: '#CDA15C' })
    .onClick(() => this.logout())
  }
}
// 服务页面
// 查拉图斯特拉如是说

import { promptAction } from '@kit.ArkUI'
import { ToastUtils, ServiceToggleCard } from 'common_uicomponents'
import { TokenStore } from 'common_datastore'
import { WeatherService, getCitiesByDistance } from 'common_weather'
import { WeatherAnimator, getWeatherAnimator, RainDrop, WeatherConditionType } from 'common_uicomponents'
import { ServiceViewModel } from '../viewmodel/ServiceViewModel.ets'
import { WEATHER_TIPS } from '../model/ServiceModel.ets'
import type { WeatherData, CityInfo, WeatherTip } from 'common_weather'
import type { NavPathStackInterface } from 'common_datastore'

@ComponentV2
export struct ServicePage {
  @Local viewModel: ServiceViewModel = new ServiceViewModel()
  @Param pathStack: NavPathStackInterface | undefined = undefined
  @Local isSosCalling: boolean = false
  @Local cloudOffset: number = 0
  @Local rainDrops: RainDrop[] = []
  @Local snowDrops: RainDrop[] = []
  @Local currentWeather: WeatherData | null = null
  @Local isLoadingWeather: boolean = true

  // 城市列表（按距离东莞排序）
  private cities: CityInfo[] = getCitiesByDistance()
  private weatherAnimator: WeatherAnimator = getWeatherAnimator()

  // 获取当前城市
  private get currentCity(): CityInfo {
    return this.cities[this.viewModel.weatherViewModel.selectedCityIndex] || this.cities[0]
  }

  // 获取天气文字描述
  private getConditionText(condition: WeatherConditionType): string {
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
  private getWeatherTipInfo(): WeatherTip {
    if (!this.currentWeather) return WEATHER_TIPS[1]
    const tip = WEATHER_TIPS.find(t => t.condition === this.currentWeather!.condition)
    return tip || WEATHER_TIPS[1]
  }

  // 加载天气数据
  private async loadWeather(): Promise<void> {
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

  aboutToAppear(): void {
    this.viewModel.aboutToAppear()
    this.viewModel.pathStack = this.pathStack

    // 设置动画回调
    this.weatherAnimator.setCallbacks(
      (offset: number) => { this.cloudOffset = offset },
      (drops: RainDrop[]) => { this.rainDrops = drops },
      (drops: RainDrop[]) => { this.snowDrops = drops }
    )

    this.loadWeather()
  }

  aboutToDisappear(): void {
    this.weatherAnimator.stopAll()
  }

  // 退出登录
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

  // 处理SOS点击
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
          this.TitleBar()
          this.ServiceSwitchArea()
          this.SosCard()
          this.WeatherCard()
          this.LogoutCard()

          Blank()
            .height(120)
        }
        .padding({
          left: 24,
          right: 24,
          bottom: 24
        })
      }
      .scrollBar(BarState.On)
    }
    .width('100%')
    .height('100%')
    .clip(true)
  }

  @Builder
  private TitleBar() {
    Column() {
      Text('服务控制')
        .fontSize(38)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F5D8A3')

      Divider()
        .width(80)
        .height(2)
        .color('#D6B16A')
        .margin({ top: 8 })
    }
    .width('100%')
    .padding({ top: 60, bottom: 30 })
  }

  @Builder
  private ServiceSwitchArea() {
    Row({ space: 18 }) {
      ServiceToggleCard({
        icon: $r('app.media.service_icon_do_not_disturb'),
        title: '请勿打扰',
        isOn: this.viewModel.disturbMode,
        onToggleHandler: () => this.viewModel.toggleDisturbMode()
      })

      ServiceToggleCard({
        icon: $r('app.media.service_icon_clean_room'),
        title: '清理房间',
        isOn: this.viewModel.cleanRoom,
        onToggleHandler: () => this.viewModel.toggleCleanRoom()
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
    .border({
      width: 1,
      color: this.isSosCalling ? '#FF4444' : '#6EA8FF'
    })
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
      if (this.currentWeather && this.currentWeather.condition === 'sunny') {
        Image($r('app.media.service_sun'))
          .width(100)
          .height(100)
          .position({ x: '68%', y: 15 })
      }

      // 云朵动画（仅多云显示）
      if (this.currentWeather && this.currentWeather.condition === 'cloudy') {
        Row() {
          Circle().width(40).height(40).fill('#FFFFFF').opacity(0.6)
          Circle().width(50).height(50).fill('#FFFFFF').opacity(0.7)
          Circle().width(35).height(35).fill('#FFFFFF').opacity(0.6)
        }
        .translate({ x: this.cloudOffset, y: 20 })
      }

      // 雨滴动画（雨天显示）
      if (this.currentWeather && this.currentWeather.condition === 'rainy') {
        ForEach(this.rainDrops, (drop: RainDrop) => {
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
      if (this.currentWeather && this.currentWeather.condition === 'snowy') {
        ForEach(this.snowDrops, (drop: RainDrop) => {
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
      TextInput({ placeholder: '输入城市名搜索', text: this.viewModel.weatherViewModel.citySearchText })
        .width('100%')
        .height(44)
        .fontSize(16)
        .fontColor('#FFFFFF')
        .placeholderColor('rgba(255,255,255,0.5)')
        .backgroundColor('rgba(255,255,255,0.15)')
        .borderRadius(8)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          this.viewModel.weatherViewModel.updateCitySearch(value)
        })
        .onSubmit(() => {
          this.viewModel.weatherViewModel.applyFirstResult()
          this.loadWeather()
        })
    }
    .width('100%')
    .margin({ bottom: 8 })
  }

  @Builder
  private SearchResultsList() {
    if (this.viewModel.weatherViewModel.searchResults.length > 0 && this.viewModel.weatherViewModel.citySearchText.length > 0) {
      Column() {
        Scroll() {
          Column() {
            ForEach(this.viewModel.weatherViewModel.searchResults, (city: CityInfo) => {
              Text(city.name + (city.distance !== undefined ? ` (${city.distance}km)` : ''))
                .fontSize(14)
                .fontColor(this.isCitySelected(city) ? '#E8C27F' : '#FFFFFF')
                .width('100%')
                .padding({ top: 8, bottom: 8 })
                .onClick(() => {
                  this.viewModel.weatherViewModel.selectCity(this.viewModel.weatherViewModel.getCityIndexByAdcode(city.adcode))
                  this.loadWeather()
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

  private isCitySelected(city: CityInfo): boolean {
    return this.viewModel.weatherViewModel.selectedCityIndex === this.viewModel.weatherViewModel.getCityIndexByAdcode(city.adcode)
  }

  @Builder
  private WeatherInfo() {
    Column() {
      // 城市名称
      Text(this.currentCity.name)
        .fontSize(16)
        .fontColor('rgba(255,255,255,0.8)')
        .margin({ bottom: 4 })

      // 温度和天气信息
      Row() {
        Column() {
          if (this.currentWeather) {
            Text(this.currentWeather.temperature.toString())
              .fontSize(72)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
            Text(this.getConditionText(this.currentWeather.condition))
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
          if (this.currentWeather) {
            Text('湿度 ' + this.currentWeather.humidity + '%')
              .fontSize(14)
              .fontColor('rgba(255,255,255,0.85)')
            Text(this.currentWeather.windDirection + ' ' + this.currentWeather.windPower)
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
    .padding({
      left: 24,
      right: 24
    })
    .backgroundColor('rgba(10,28,65,0.88)')
    .borderRadius(24)
    .border({ width: 1, color: '#CDA15C' })
    .onClick(() => this.logout())
  }
}
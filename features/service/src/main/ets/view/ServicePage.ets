// 服务页面
// 查拉图斯特拉如是说

import { promptAction } from '@kit.ArkUI'
import { ToastUtils } from 'common_uicomponents'
import { TokenStore } from 'common_datastore'
import { WeatherService, getCitiesByDistance } from 'common_weather'
import { ServiceViewModel } from '../viewmodel/ServiceViewModel.ets'
import { WEATHER_TIPS, getWeatherTip } from '../model/ServiceModel.ets'
import type { WeatherData, CityInfo, WeatherCondition, WeatherTip, RainDrop } from 'common_weather'
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

  // 定时器ID
  private cloudTimer: number = -1
  private rainTimer: number = -1
  private snowTimer: number = -1
  private rainMoveTimer: number = -1
  private snowMoveTimer: number = -1

  // 获取当前城市
  private get currentCity(): CityInfo {
    return this.cities[this.viewModel.weatherViewModel.selectedCityIndex] || this.cities[0]
  }

  // 获取天气文字描述
  private getConditionText(condition: WeatherCondition): string {
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
  private getWeatherTip(): WeatherTip {
    if (!this.currentWeather) return WEATHER_TIPS[1]
    const tip = WEATHER_TIPS.find(t => t.condition === this.currentWeather!.condition)
    return tip || WEATHER_TIPS[1]
  }

  // 获取背景颜色 - 和其他卡片一致
  private getBackgroundColor(): string {
    return 'rgba(10,28,65,0.88)'
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
      } else {
        // 使用默认数据
        this.currentWeather = {
          city: this.currentCity.name,
          temperature: 0,
          condition: 'cloudy',
          humidity: 50,
          windDirection: '',
          windPower: ''
        }
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
    this.startWeatherAnimation()
    this.loadWeather()
  }

  aboutToDisappear(): void {
    this.stopWeatherAnimation()
  }

  // 启动天气动画
  startWeatherAnimation(): void {
    // 云朵动画
    this.cloudTimer = setInterval(() => {
      this.cloudOffset += 2
      if (this.cloudOffset > 350) {
        this.cloudOffset = -150
      }
    }, 50)

    // 雨滴生成
    this.rainTimer = setInterval(() => {
      if (this.currentWeather?.condition === 'rainy') {
        let drop: RainDrop = {
          id: Date.now() + Math.random(),
          x: Math.random() * 280 + 10,
          y: 0,
          speed: Math.random() * 5 + 3,
          length: Math.random() * 15 + 10
        }
        this.rainDrops.push(drop)
        if (this.rainDrops.length > 30) {
          this.rainDrops.shift()
        }
      }
    }, 100)

    // 雨滴移动
    this.rainMoveTimer = setInterval(() => {
      if (this.currentWeather?.condition === 'rainy') {
        let updated: RainDrop[] = []
        for (let i = 0; i < this.rainDrops.length; i++) {
          let d = this.rainDrops[i]
          let newY: number = d.y + d.speed
          if (newY < 200) {
            updated.push({
              id: d.id,
              x: d.x,
              y: newY,
              speed: d.speed,
              length: d.length
            })
          }
        }
        this.rainDrops = updated
      } else {
        this.rainDrops = []
      }
    }, 50)

    // 雪花生成
    this.snowTimer = setInterval(() => {
      if (this.currentWeather?.condition === 'snowy') {
        let drop: RainDrop = {
          id: Date.now() + Math.random(),
          x: Math.random() * 280 + 10,
          y: 0,
          speed: Math.random() * 2 + 1,
          length: Math.random() * 4 + 3
        }
        this.snowDrops.push(drop)
        if (this.snowDrops.length > 40) {
          this.snowDrops.shift()
        }
      }
    }, 150)

    // 雪花移动
    this.snowMoveTimer = setInterval(() => {
      if (this.currentWeather?.condition === 'snowy') {
        let updated: RainDrop[] = []
        for (let i = 0; i < this.snowDrops.length; i++) {
          let d = this.snowDrops[i]
          let newY: number = d.y + d.speed
          let newX: number = d.x + Math.sin(newY * 0.05) * 0.5
          if (newY < 200) {
            updated.push({
              id: d.id,
              x: newX,
              y: newY,
              speed: d.speed,
              length: d.length
            })
          }
        }
        this.snowDrops = updated
      } else {
        this.snowDrops = []
      }
    }, 50)
  }

  // 停止天气动画
  stopWeatherAnimation(): void {
    if (this.cloudTimer !== -1) {
      clearInterval(this.cloudTimer)
      this.cloudTimer = -1
    }
    if (this.rainTimer !== -1) {
      clearInterval(this.rainTimer)
      this.rainTimer = -1
    }
    if (this.rainMoveTimer !== -1) {
      clearInterval(this.rainMoveTimer)
      this.rainMoveTimer = -1
    }
    if (this.snowTimer !== -1) {
      clearInterval(this.snowTimer)
      this.snowTimer = -1
    }
    if (this.snowMoveTimer !== -1) {
      clearInterval(this.snowMoveTimer)
      this.snowMoveTimer = -1
    }
  }

  // 退出登录
  private async logout(): Promise<void> {
    // 1. 弹出确认对话框
    const action = await promptAction.showDialog({
      title: '退出登录',
      message: '确定要退出登录吗？',
      buttons: [
        { text: '取消', color: '#666666' },
        { text: '确定', color: '#E8C27F' }
      ]
    })

    // 2. 用户确认后执行登出
    if (action.index === 1) {
      // 清除 AppStorage
      AppStorage.setOrCreate('token', '')
      AppStorage.setOrCreate('loginTime', 0)
      AppStorage.setOrCreate('isLogin', false)
      AppStorage.setOrCreate('firstName', '')

      // 清除 Preferences token（保留 roomNo）
      const tokenStore = TokenStore.getInstance()
      tokenStore.clearToken()

      ToastUtils.show('已退出登录')

      // 3. 使用NavPathStack导航到登录页
      if (this.pathStack) {
        this.pathStack.clear()
        this.pathStack.pushPathByName('login', null)
      }
    }
  }

  build() {
    Stack() {
      // 背景
      Image($r('app.media.service_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 深色蒙层
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
      // 请勿打扰卡片
      Column() {
        Image($r('app.media.service_icon_do_not_disturb'))
          .width(100)
          .height(100)

        Text('请勿打扰')
          .fontSize(28)
          .fontColor(this.viewModel.disturbMode ? '#DDB97A' : '#F4D39A')
          .margin({ top: 20 })

        Image(this.viewModel.disturbMode ? $r('app.media.service_toggle_on') : $r('app.media.service_toggle_off'))
          .width(70)
          .height(70)
          .onClick(() => {
            this.viewModel.toggleDisturbMode()
          })
          .margin({ top: 30 })
      }
      .width('48%')
      .height(300)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.viewModel.disturbMode ? 'rgba(255,215,120,0.15)' : 'rgba(0,30,80,0.92)')
      .borderRadius(24)
      .border({ width: 1, color: this.viewModel.disturbMode ? '#DDB97A' : '#6EA8FF' })
      .shadow({
        radius: 25,
        color: this.viewModel.disturbMode ? 'rgba(255,215,120,0.25)' : 'rgba(80,120,255,0.25)'
      })

      // 清理房间卡片
      Column() {
        Image($r('app.media.service_icon_clean_room'))
          .width(100)
          .height(100)

        Text('清理房间')
          .fontSize(28)
          .fontColor(this.viewModel.cleanRoom ? '#DDB97A' : '#F4D39A')
          .margin({ top: 20 })

        Image(this.viewModel.cleanRoom ? $r('app.media.service_toggle_on') : $r('app.media.service_toggle_off'))
          .width(70)
          .height(70)
          .onClick(() => {
            this.viewModel.toggleCleanRoom()
          })
          .margin({ top: 30 })
      }
      .width('48%')
      .height(300)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.viewModel.cleanRoom ? 'rgba(255,215,120,0.15)' : 'rgba(0,30,80,0.92)')
      .borderRadius(24)
      .border({ width: 1, color: this.viewModel.cleanRoom ? '#DDB97A' : '#6EA8FF' })
      .shadow({
        radius: 25,
        color: this.viewModel.cleanRoom ? 'rgba(255,215,120,0.25)' : 'rgba(80,120,255,0.25)'
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

  // 处理SOS点击
  private handleSosClick(): void {
    if (this.isSosCalling) {
      return // 已在呼叫中
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

  @Builder
  private WeatherCard() {
    Stack() {
      // 背景层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(this.getBackgroundColor())
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
        // 城市搜索输入行
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

        // 搜索结果列表（当有搜索结果时显示）
        if (this.viewModel.weatherViewModel.searchResults.length > 0 && this.viewModel.weatherViewModel.citySearchText.length > 0) {
          Column() {
            Scroll() {
              Column() {
                ForEach(this.viewModel.weatherViewModel.searchResults, (city: CityInfo, index: number) => {
                  Text(city.name + (city.distance !== undefined ? ` (${city.distance}km)` : ''))
                    .fontSize(14)
                    .fontColor(this.viewModel.weatherViewModel.selectedCityIndex === this.viewModel.weatherViewModel.getCityIndexByAdcode(city.adcode) ? '#E8C27F' : '#FFFFFF')
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
        Text(this.getWeatherTip().tip)
          .fontSize(14)
          .fontColor(this.getWeatherTip().color)
          .margin({ top: 10 })
      }
      .width('100%')
      .padding(20)
    }
    .width('100%')
    .height(260)
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
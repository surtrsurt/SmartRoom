// 天气卡片
// 查拉图斯特拉如是说

import type { WeatherData, CityInfo, WeatherTip, RainDrop } from 'common_weather'

@ComponentV2
export struct ServiceWeatherCard {
  @Param currentWeather: WeatherData | null = null
  @Param currentCity: CityInfo | null = null
  @Param citySearchText: string = ''
  @Param searchResults: CityInfo[] = []
  @Param selectedCityIndex: number = 0
  @Param cloudOffset: number = 0
  @Param rainDrops: RainDrop[] = []
  @Param snowDrops: RainDrop[] = []
  @Param weatherTip: WeatherTip | null = null
  @Param conditionText: string = '多云'
  @Param onSearchChange: (text: string) => void = () => {}
  @Param onSearchSubmit: () => void = () => {}
  @Param onCitySelect: (city: CityInfo) => void = () => {}
  @Param getCityIndexByAdcode: (adcode: string) => number = () => 0

  build() {
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
        this.SearchInput()
        this.ResultsList()
        this.WeatherDisplay()
      }
      .width('100%')
      .padding(20)
    }
    .width('100%')
    .height(260)
  }

  @Builder
  private SearchInput() {
    Row() {
      TextInput({ placeholder: '输入城市名搜索', text: this.citySearchText })
        .width('100%')
        .height(44)
        .fontSize(16)
        .fontColor('#FFFFFF')
        .placeholderColor('rgba(255,255,255,0.5)')
        .backgroundColor('rgba(255,255,255,0.15)')
        .borderRadius(8)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          this.onSearchChange(value)
        })
        .onSubmit(() => {
          this.onSearchSubmit()
        })
    }
    .width('100%')
    .margin({ bottom: 8 })
  }

  @Builder
  private ResultsList() {
    if (this.searchResults.length > 0 && this.citySearchText.length > 0) {
      Column() {
        Scroll() {
          Column() {
            ForEach(this.searchResults, (city: CityInfo) => {
              Text(city.name + (city.distance !== undefined ? ` (${city.distance}km)` : ''))
                .fontSize(14)
                .fontColor(this.selectedCityIndex === this.getCityIndexByAdcode(city.adcode) ? '#E8C27F' : '#FFFFFF')
                .width('100%')
                .padding({ top: 8, bottom: 8 })
                .onClick(() => {
                  this.onCitySelect(city)
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
  private WeatherDisplay() {
    Column() {
      // 城市名称
      Text(this.currentCity?.name ?? '--')
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
            Text(this.conditionText)
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
      Text(this.weatherTip?.tip ?? '')
        .fontSize(14)
        .fontColor(this.weatherTip?.color ?? '#FFFFFF')
        .margin({ top: 10 })
    }
  }
}
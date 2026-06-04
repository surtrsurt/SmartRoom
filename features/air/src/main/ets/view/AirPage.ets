//空调组件（不独立页面，供HomePage使用）
//查拉图斯特拉如是说

import { AirModeNames, AirSpeedNames } from '../model/AirModel.ets'
import type { AirState } from '../model/AirModel.ets'
import { ToastUtils } from 'common_uicomponents'
import { AirRepository } from '../repository/AirRepository.ets'

// 导出AirRepository供其他模块使用
export { AirRepository }

// AirConditionerCard组件定义...

@ComponentV2
export struct AirConditionerCard {
  @Param airState: AirState = { power: false, mode:0, temp:24, speed:0 }
  @Param onPowerChange: (power: boolean) => void = () => {}
  @Param onTempChange: (temp: number) => void = () => {}
  @Param onModeChange: (mode: number) => void = () => {}

  build() {
    Column() {
      Text('空调')
        .fontSize(18)
        .fontWeight(600)
        .fontColor('#FFFFFF')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom:16 })

      //空调图标
      if (this.airState.power) {
        Image($r('app.media.home_icon_airconditioner_select'))
          .width(210)
          .height(140)
          .objectFit(ImageFit.Contain)
          .alignSelf(ItemAlign.Center)
          .margin({ bottom: 16 })
      } else {
        Image($r('app.media.home_icon_airconditioner_unselect'))
          .width(120)
          .height(60)
          .objectFit(ImageFit.Contain)
          .alignSelf(ItemAlign.Center)
          .margin({ bottom: 16 })
      }

      if (this.airState.power) {
        //温度显示
        Row() {
          Text(`${this.airState.temp}`)
            .fontSize(36)
            .fontColor('#FACC15')
            .fontWeight(300)
          Text('°C')
            .fontSize(20)
            .fontColor('#FACC15')
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')

        //温度控制行
        Row() {
          Image($r('app.media.home_btn_sub'))
            .width(50)
            .height(50)
            .borderRadius(16)
            .backgroundColor('rgba(40,40,40,0.6)')
            .borderWidth(1)
            .borderColor('rgba(250,204,21,0.4)')
            .onClick(() => {
              const newTemp = this.airState.temp - 1
              if (newTemp >= 16) {
                this.airState.temp = newTemp
                this.onTempChange(newTemp)
                ToastUtils.show(`温度已调整为${newTemp}°C`)
              }
            })

          Text(AirModeNames.getName(this.airState.mode))
            .fontSize(14)
            .fontColor('#FFFFFF')
            .margin({ left:20, right:20 })

          Image($r('app.media.home_btn_add'))
            .width(50)
            .height(50)
            .borderRadius(16)
            .backgroundColor('rgba(40,40,40,0.6)')
            .borderWidth(1)
            .borderColor('rgba(250,204,21,0.4)')
            .onClick(() => {
              const newTemp = this.airState.temp + 1
              if (newTemp <= 30) {
                this.airState.temp = newTemp
                this.onTempChange(newTemp)
                ToastUtils.show(`温度已调整为${newTemp}°C`)
              }
            })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .margin({ top:16 })

        //电源按钮
        Row() {
          Column() {
            Image($r('app.media.home_icon_close'))
              .width(60)
              .height(60)
              .onClick(() => {
                this.onPowerChange(false)
                ToastUtils.show('空调已关闭')
              })
          }
          .width(90)
          .height(90)
          .borderRadius(45)
          .backgroundColor('rgba(30,30,30,0.8)')
          .borderWidth(2)
          .borderColor('#FACC15')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .margin({ top:16 })

        //模式行
        Row() {
          Column() {
            Image(this.airState.mode === 0 ? $r('app.media.home_auto_mode_select') : $r('app.media.home_auto_mode_unselect'))
              .width(48)
              .height(48)
            Text('自动模式')
              .fontSize(12)
              .fontColor(this.airState.mode === 0 ? '#FACC15' : '#FFFFFF')
              .margin({ top: 4 })
          }
          .flexGrow(1)
          .height(56)
          .borderRadius(20)
          .backgroundColor(this.airState.mode === 0 ? 'rgba(250,204,21,0.2)' : 'rgba(30,30,30,0.5)')
          .borderWidth(1)
          .borderColor(this.airState.mode === 0 ? '#FACC15' : 'rgba(250,204,21,0.4)')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.onModeChange(0)
            if (this.airState.mode === 0) {
              ToastUtils.show('自动模式已关闭')
            } else {
              ToastUtils.show('已切换到自动模式')
            }
          })

          Column() {
            Image(this.airState.mode === 1 ? $r('app.media.home_powerful_mode_select') : $r('app.media.home_powerful_mode_unselect'))
              .width(48)
              .height(48)
            Text('强劲模式')
              .fontSize(12)
              .fontColor(this.airState.mode === 1 ? '#FACC15' : '#FFFFFF')
              .margin({ top: 4 })
          }
          .flexGrow(1)
          .height(56)
          .borderRadius(20)
          .backgroundColor(this.airState.mode === 1 ? 'rgba(250,204,21,0.2)' : 'rgba(30,30,30,0.5)')
          .borderWidth(1)
          .borderColor(this.airState.mode === 1 ? '#FACC15' : 'rgba(250,204,21,0.4)')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .margin({ left: 12 })
          .onClick(() => {
            this.onModeChange(1)
            if (this.airState.mode === 1) {
              ToastUtils.show('强劲模式已关闭')
            } else {
              ToastUtils.show('已切换到强劲模式')
            }
          })
        }
        .margin({ top: 16 })
      } else {
        //关闭状态
        Row() {
          Text('已关闭')
            .fontSize(16)
            .fontColor('#FFFFFF')
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .margin({ top:20 })

        //电源按钮开启
        Row() {
          Column() {
            Image($r('app.media.home_icon_close'))
              .width(60)
              .height(60)
              .onClick(() => {
                this.onPowerChange(true)
                ToastUtils.show('空调已开启')
              })
          }
          .width(90)
          .height(90)
          .borderRadius(45)
          .backgroundColor('rgba(30,30,30,0.8)')
          .borderWidth(2)
          .borderColor('#FACC15')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .margin({ top: 20 })
      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(7,27,64,0.6)')
    .borderRadius(24)
    .border({ width:1, color: 'rgba(255,255,255,0.2)' })
    .backdropBlur(15)
    .shadow({ radius:10, color: 'rgba(0,0,0,0.2)', offsetX:0, offsetY:4 })
  }
}
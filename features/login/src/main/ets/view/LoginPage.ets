// 登录页面组件
// 查拉图斯特拉如是说

import router from '@ohos.router'
import { LoginViewModel } from '../viewmodel/LoginViewModel.ets'

@Component
export struct LoginPage {
  @State viewModel: LoginViewModel = new LoginViewModel()

  build() {
    Stack() {
      // 背景图 - Stack底层
      Image($r('app.media.bg_hotel_full'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 内容层 - 玻璃拟态
      Column() {
        Column() {
          Image($r('app.media.home_text_smart_guest_room'))
            .width(250)
            .height(100)
            .objectFit(ImageFit.Contain)

          Image($r('app.media.home_text_login'))
            .width(350)
            .height(150)
            .objectFit(ImageFit.Contain)

          Column() {
            Column() {
              Row() {
                Image($r('app.media.icon_input_room'))
                  .width(75)
                  .height(75)
                TextInput({ placeholder: '请输入房间号', text: this.viewModel.roomNo })
                  .width('100%')
                  .height(48)
                  .fontSize(16)
                  .backgroundColor(Color.Transparent)
                  .placeholderColor('#99FFFFFF')
                  .fontColor('#FFFFFF')
                  .onChange((value) => {
                    this.viewModel.setRoomNo(value)
                  })
              }
              .width('100%')
              .height(48)
              .backgroundColor('rgba(255, 255, 255, 0.15)')
              .borderRadius(24)
              .padding({ left: 0, right: 16 })
              .margin({ top: 60 })

              Row() {
                Image($r('app.media.icon_input_user'))
                  .width(75)
                  .height(75)
                TextInput({ placeholder: '请输入用户名', text: this.viewModel.userName })
                  .width('100%')
                  .height(48)
                  .fontSize(16)
                  .backgroundColor(Color.Transparent)
                  .placeholderColor('#99FFFFFF')
                  .fontColor('#FFFFFF')
                  .onChange((value) => {
                    this.viewModel.setUserName(value)
                  })
              }
              .width('100%')
              .height(48)
              .backgroundColor('rgba(255, 255, 255, 0.15)')
              .borderRadius(24)
              .padding({ left: 0, right: 16 })
              .margin({ top: 16 })

              Row() {
                Image(this.viewModel.rememberMe ? $r('app.media.icon_input_checked') : $r('app.media.icon_input_unchecked'))
                  .width(24)
                  .height(24)
                  .onClick(() => {
                    this.viewModel.setRememberMe(!this.viewModel.rememberMe)
                  })
                Text('记住我')
                  .fontSize(14)
                  .fontColor('#FFFFFF')
                  .margin({ left: 8 })
              }
              .margin({ top: 16 })

              Button(this.viewModel.isLoading ? '登录中...' : '登录')
                .width('100%')
                .height(48)
                .fontSize(18)
                .fontColor('#FFFFFF')
                .backgroundColor('#D9AF7C')
                .borderRadius(24)
                .margin({ top: 32 })
                .enabled(!this.viewModel.isLoading)
                .onClick(() => {
                  this.handleLogin()
                })
            }
            .width('100%')
            .padding({ left: 32, right: 32 })
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 20, bottom: 20 })
          .backgroundColor('rgba(7, 27, 64, 0.8)')
          .borderRadius(30)
          .border({
            width: 1,
            color: 'rgba(255, 255, 255, 0.3)'
          })
          .backdropBlur(20)
          .shadow({
            radius: 15,
            color: 'rgba(0, 0, 0, 0.3)',
            offsetX: 0,
            offsetY: 5
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ top: 60 })
      }
    }
    .width('100%')
    .height('100%')
  }

  async handleLogin(): Promise<void> {
    const success = await this.viewModel.login()
    if (success) {
      router.replaceUrl({ url: 'pages/MainPage' })
    }
  }
}
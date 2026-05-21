import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { LoginViewModel } from '../features/login/viewmodel/LoginViewModel'
import { LoginInput } from '../features/login/components/LoginInput'

@Entry
@Component
struct LoginPage {
  @State viewModel: LoginViewModel = new LoginViewModel()

  aboutToAppear() {
    this.viewModel.loadSavedState()
  }

  build() {
    Stack() {
      // 背景图
      Image($r('app.media.bg_hotel_full'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        // 智慧客房标题图
        Image($r('app.media.home_text_smart_guest_room'))
          .width('60%')
          .objectFit(ImageFit.Contain)
          .margin({ top: '10%' })

        // 登录表单白色圆角卡片
        Column() {
          // 客房号输入框
          LoginInput({
            icon: $r('app.media.icon_input_room'),
            placeholder: '请输入客房号',
            value: this.viewModel.roomNo,
            onChange: (value: string) => {
              this.viewModel.setRoomNo(value)
            }
          })

          Blank().height(12)

          // 用户名输入框
          LoginInput({
            icon: $r('app.media.icon_input_user'),
            placeholder: '请输入姓名',
            value: this.viewModel.firstName,
            onChange: (value: string) => {
              this.viewModel.setFirstName(value)
            }
          })

          Blank().height(12)

          // 记住我
          Row() {
            Image(this.viewModel.isRememberChecked ?
              $r('app.media.icon_input_checked') :
              $r('app.media.icon_input_unchecked'))
              .width(20)
              .height(20)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.viewModel.toggleRemember()
              })

            Text('记住我')
              .fontSize(14)
              .fontColor('#666666')
              .margin({ left: 8 })
              .onClick(() => {
                this.viewModel.toggleRemember()
              })
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)

          Blank().height(24)

          // 登录按钮
          Button('登录')
            .width('100%')
            .height(48)
            .borderRadius(24)
            .backgroundColor('#1A5EDA')
            .enabled(!this.viewModel.isLoading)
            .onClick(async () => {
              const success = await this.viewModel.login()
              if (success) {
                router.pushUrl({ url: 'pages/HomePage' })
              } else {
                promptAction.showToast({ message: this.viewModel.errorMsg })
              }
            })

          // 错误提示
          if (this.viewModel.errorMsg) {
            Text(this.viewModel.errorMsg)
              .fontSize(12)
              .fontColor('#FF4444')
              .margin({ top: 8 })
          }
        }
        .width('85%')
        .padding(24)
        .backgroundColor('#80FFFFFF')
        .borderRadius(24)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}
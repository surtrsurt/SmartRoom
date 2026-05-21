@Component
export struct LoginInput {
  @Prop icon: ResourceStr = ''
  @Prop placeholder: string = ''
  @Prop value: string = ''
  onChange: (value: string) => void = (_v: string) => {}

  build() {
    Row() {
      Image(this.icon)
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)

      TextInput({ placeholder: this.placeholder, text: this.value })
        .placeholderFont({ size: 14, weight: FontWeight.Normal })
        .caretColor('#333333')
        .fontSize(14)
        .fontColor('#333333')
        .backgroundColor(Color.Transparent)
        .layoutWeight(1)
        .margin({ left: 12 })
        .height(50)
        .onChange((value: string) => {
          this.onChange(value)
        })
    }
    .width('100%')
    .height(50)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .alignItems(VerticalAlign.Center)
  }
}
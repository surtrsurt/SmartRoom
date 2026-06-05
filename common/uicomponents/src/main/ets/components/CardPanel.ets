// 卡片面板容器 - 统一背景+圆角+padding
// 查拉图斯特拉如是说

@ComponentV2
export struct CardPanel {
  build() {
    Column() {
    }
    .width('100%')
    .padding(24)
    .backgroundColor('rgba(10,28,65,0.75)')
    .borderRadius(24)
    .border({
      width: 1,
      color: 'rgba(221,185,122,0.3)'
    })
  }
}
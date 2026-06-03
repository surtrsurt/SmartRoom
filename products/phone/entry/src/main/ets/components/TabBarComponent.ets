// TabBar组件
// 查拉图斯特拉如是说

interface TabItem {
  title: string
  selectIcon: Resource
  unselectIcon: Resource
}

@Component
export struct TabBar {
  @Prop currentIndex: number = 0
  onTabChange: (index: number) => void = () => {}

  private tabs: TabItem[] = [
    {
      title: '首页',
      selectIcon: $r('app.media.tabs_icon_home_select'),
      unselectIcon: $r('app.media.tabs_icon_home_unselect')
    },
    {
      title: '灯光',
      selectIcon: $r('app.media.tabs_icon_light_select'),
      unselectIcon: $r('app.media.tabs_icon_light_unselect')
    },
    {
      title: '窗帘',
      selectIcon: $r('app.media.tabs_icon_curtain_select'),
      unselectIcon: $r('app.media.tabs_icon_curtain_unselect')
    },
    {
      title: '服务',
      selectIcon: $r('app.media.tabs_icon_service_select'),
      unselectIcon: $r('app.media.tabs_icon_service_unselect')
    }
  ]

  build() {
    Column() {
      Image($r('app.media.tabs_bg'))
        .width('100%')
        .height(80)
        .objectFit(ImageFit.Cover)

      Row() {
        ForEach(this.tabs, (tab: TabItem, index: number) => {
          Column() {
            Stack({ alignContent: Alignment.Center }) {
              if (this.currentIndex === index) {
                Image($r('app.media.tabs_icon_bg_selected'))
                  .width(90)
                  .height(90)
                  .align(Alignment.Center)
                  .zIndex(0)
              }

              Column() {
                Image(this.currentIndex === index ? tab.selectIcon : tab.unselectIcon)
                  .width(48)
                  .height(48)
                Text(tab.title)
                  .fontSize(12)
                  .fontColor(this.currentIndex === index ? '#FACC15' : '#999999')
              }
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .zIndex(1)
            }
            .width(90)
            .height(90)
          }
          .flexGrow(1)
          .alignItems(HorizontalAlign.Center)
          .onClick(() => {
            this.onTabChange(index)
          })
        })
      }
      .width('100%')
      .height(80)
      .position({ y: 0 })
      .padding({ left: 8, right: 8 })
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .height(80)
    .alignItems(HorizontalAlign.Center)
  }
}
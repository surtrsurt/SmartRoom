// 窗帘页面
// 查拉图斯特拉如是说

import { CurtainViewModel } from '../viewmodel/CurtainViewModel.ets'

@ComponentV2
export struct CurtainPage {
  @Local viewModel: CurtainViewModel = new CurtainViewModel()

  // 动画时长(ms)
  private animationDuration: number = 500
  // 动画步进间隔(ms)
  private animationStep: number = 16
  // 布帘动画定时器
  private clothAnimationTimer: number = -1
  // 窗纱动画定时器
  private gauzeAnimationTimer: number = -1
  // 布帘动画目标（1.0=打开，0.0=关闭）
  private clothTarget: number = 0
  // 窗纱动画目标
  private gauzeTarget: number = 0

  aboutToAppear(): void {
    this.viewModel.initState()
  }

  build() {
    Stack() {
      // 背景图
      Image($r('app.media.curtain_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 深色蒙层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,10,30,0.3)')

      Column() {
        // 标题
        Column() {
          Text('窗帘控制')
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

        Scroll() {
          Column({ space: 16 }) {
            // 全部打开/全部关闭
            this.TopControlButtons()

            // 布帘控制卡片
            this.CurtainControlCard('布帘', true)

            // 窗纱控制卡片
            this.CurtainControlCard('窗纱', false)

            Blank()
              .height(100)
          }
          .padding(16)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .clip(true)
  }

  // 处理打开
  handleOpen(vm: CurtainViewModel, type: string): void {
    if (type === 'cloth') {
      // 如果是暂停状态，恢复动画到打开
      if (vm.clothState === 'paused') {
        vm.clothState = 'opening'
        this.startClothAnimation(1.0)
        return
      }
      if (vm.clothState === 'opening' || vm.clothState === 'opened') {
        return
      }
      vm.clothState = 'opening'
      vm.selectedControl = 'cloth'
      this.startClothAnimation(1.0)
    } else {
      // 如果是暂停状态，恢复动画到打开
      if (vm.gauzeState === 'paused') {
        vm.gauzeState = 'opening'
        this.startGauzeAnimation(1.0)
        return
      }
      if (vm.gauzeState === 'opening' || vm.gauzeState === 'opened') {
        return
      }
      vm.gauzeState = 'opening'
      vm.selectedControl = 'gauze'
      this.startGauzeAnimation(1.0)
    }
  }

  // 处理关闭
  handleClose(vm: CurtainViewModel, type: string): void {
    if (type === 'cloth') {
      // 如果是暂停状态，恢复动画到关闭
      if (vm.clothState === 'paused') {
        vm.clothState = 'closing'
        this.startClothAnimation(0.0)
        return
      }
      if (vm.clothState === 'closing' || vm.clothState === 'closed') {
        return
      }
      vm.clothState = 'closing'
      vm.selectedControl = 'cloth'
      this.startClothAnimation(0.0)
    } else {
      // 如果是暂停状态，恢复动画到关闭
      if (vm.gauzeState === 'paused') {
        vm.gauzeState = 'closing'
        this.startGauzeAnimation(0.0)
        return
      }
      if (vm.gauzeState === 'closing' || vm.gauzeState === 'closed') {
        return
      }
      vm.gauzeState = 'closing'
      vm.selectedControl = 'gauze'
      this.startGauzeAnimation(0.0)
    }
  }

  // 启动布帘动画
  private startClothAnimation(targetPercent: number): void {
    // 停止之前的动画
    if (this.clothAnimationTimer >= 0) {
      clearInterval(this.clothAnimationTimer)
      this.clothAnimationTimer = -1
    }
    this.clothTarget = targetPercent

    const step = (targetPercent - this.viewModel.clothPercent) / (this.animationDuration / this.animationStep)
    this.clothAnimationTimer = setInterval(() => {
      const vm = this.viewModel
      if (vm.clothState === 'paused') {
        return // 暂停时不更新
      }
      const current = vm.clothPercent
      const newPercent = targetPercent > current ? Math.min(current + step, targetPercent) : Math.max(current + step, targetPercent)
      vm.updateClothPercent(newPercent)
      // 判断是否到达目标
      if ((step > 0 && newPercent >= targetPercent) || (step < 0 && newPercent <= targetPercent)) {
        clearInterval(this.clothAnimationTimer)
        this.clothAnimationTimer = -1
        if (targetPercent === 1.0) {
          vm.updateClothPercent(1.0)
          vm.syncClothToStore()
        } else {
          vm.updateClothPercent(0)
          vm.syncClothClosedToStore()
        }
      }
    }, this.animationStep)
  }

  // 启动窗纱动画
  private startGauzeAnimation(targetPercent: number): void {
    if (this.gauzeAnimationTimer >= 0) {
      clearInterval(this.gauzeAnimationTimer)
      this.gauzeAnimationTimer = -1
    }
    this.gauzeTarget = targetPercent

    const step = (targetPercent - this.viewModel.gauzePercent) / (this.animationDuration / this.animationStep)
    this.gauzeAnimationTimer = setInterval(() => {
      const vm = this.viewModel
      if (vm.gauzeState === 'paused') {
        return
      }
      const current = vm.gauzePercent
      const newPercent = targetPercent > current ? Math.min(current + step, targetPercent) : Math.max(current + step, targetPercent)
      vm.updateGauzePercent(newPercent)
      if ((step > 0 && newPercent >= targetPercent) || (step < 0 && newPercent <= targetPercent)) {
        clearInterval(this.gauzeAnimationTimer)
        this.gauzeAnimationTimer = -1
        if (targetPercent === 1.0) {
          vm.updateGauzePercent(1.0)
          vm.syncGauzeToStore()
        } else {
          vm.updateGauzePercent(0)
          vm.syncGauzeClosedToStore()
        }
      }
    }, this.animationStep)
  }

  // 处理全部打开
  handleOpenAll(): void {
    this.viewModel.selectedControl = 'allOpen'
    this.viewModel.clothState = 'opening'
    this.viewModel.gauzeState = 'opening'
    this.startClothAnimation(1.0)
    this.startGauzeAnimation(1.0)
  }

  // 处理全部关闭
  handleCloseAll(): void {
    this.viewModel.selectedControl = 'allClose'
    this.viewModel.clothState = 'closing'
    this.viewModel.gauzeState = 'closing'
    this.startClothAnimation(0.0)
    this.startGauzeAnimation(0.0)
  }

  // 处理暂停
  handlePause(vm: CurtainViewModel, type: string): void {
    // 同时暂停布帘和窗纱（无论当前是全部操作还是单独操作）
    if (vm.clothState === 'opening' || vm.clothState === 'closing') {
      vm.clothState = 'paused'
    }
    if (vm.gauzeState === 'opening' || vm.gauzeState === 'closing') {
      vm.gauzeState = 'paused'
    }
  }

  // 全部打开/全部关闭按钮
  @Builder
  TopControlButtons() {
    Row({ space: 12 }) {
      Column() {
        Image($r('app.media.curtain_icon_open_all'))
          .width(120)
          .height(120)
        Text('全部打开')
          .fontSize(18)
          .fontColor(this.viewModel.selectedControl === 'allOpen' ? '#DDB97A' : '#F4D39A')
          .margin({ top: 8 })
      }
      .width('48%')
      .height(200)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.viewModel.selectedControl === 'allOpen' ? 'rgba(255,215,120,0.15)' : 'rgba(0,0,0,0.2)')
      .borderRadius(24)
      .border({ width: 1, color: this.viewModel.selectedControl === 'allOpen' ? '#DDB97A' : 'rgba(221,185,122,0.3)' })
      .onClick(() => this.handleOpenAll())

      Column() {
        Image($r('app.media.curtain_icon_close_all'))
          .width(120)
          .height(120)
        Text('全部关闭')
          .fontSize(18)
          .fontColor(this.viewModel.selectedControl === 'allClose' ? '#DDB97A' : '#F4D39A')
          .margin({ top: 8 })
      }
      .width('48%')
      .height(200)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.viewModel.selectedControl === 'allClose' ? 'rgba(255,215,120,0.15)' : 'rgba(0,0,0,0.2)')
      .borderRadius(24)
      .border({ width: 1, color: this.viewModel.selectedControl === 'allClose' ? '#DDB97A' : 'rgba(221,185,122,0.3)' })
      .onClick(() => this.handleCloseAll())
    }
    .width('100%')
  }

  // 窗帘/窗纱控制卡片
  @Builder
  CurtainControlCard(
    title: string,
    isCloth: boolean
  ) {
    Column() {
      // 标题行
      Row() {
        Text(title)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#E2BD93')
      }
      .width('100%')
      .margin({ bottom: 10 })

      // 状态预览区（窗帘背景 + 左右帘子）
      Stack({ alignContent: Alignment.Center }) {
        // 背景图（完全打开用 curtain_icon_bg，窗纱用 curtain_icon_window_bg）
        Image(isCloth ?
          $r('app.media.curtain_icon_bg') :
          $r('app.media.curtain_icon_window_bg'))
          .width('100%')
          .height(160)
          .objectFit(ImageFit.Cover)
          .visibility(isCloth ? (this.viewModel.clothPercent >= 1.0 ? Visibility.Visible : Visibility.None) : (this.viewModel.gauzePercent >= 1.0 ? Visibility.Visible : Visibility.None))

        // 左右帘子（可移动实现动画，无间隙）- 完全打开时隐藏
        if (isCloth ? this.viewModel.clothPercent < 1.0 : this.viewModel.gauzePercent < 1.0) {
          Stack() {
            // 左帘子
            if (isCloth) {
              Image(this.viewModel.clothPercent > 0.5 ?
                $r('app.media.curtain_icon_left_open') :
                $r('app.media.curtain_icon_left_closed'))
                .width('70%')
                .height(160)
                .objectFit(ImageFit.Cover)
                .position({ x: 0, y: 0 })
                .translate({ x: -this.viewModel.clothPercent * 60 })
            } else {
              Image(this.viewModel.gauzePercent > 0.5 ?
                $r('app.media.curtain_icon_window_screening_left_part_open') :
                $r('app.media.curtain_icon_window_screening_left_part_closed'))
                .width('70%')
                .height(160)
                .objectFit(ImageFit.Cover)
                .position({ x: 0, y: 0 })
                .translate({ x: -this.viewModel.gauzePercent * 60 })
            }

            // 右帘子（靠右）
            if (isCloth) {
              Image(this.viewModel.clothPercent > 0.5 ?
                $r('app.media.curtain_icon_right_open') :
                $r('app.media.curtain_icon_right_closed'))
                .width('70%')
                .height(160)
                .objectFit(ImageFit.Cover)
                .position({ x: '30%', y: 0 })
                .translate({ x: this.viewModel.clothPercent * 60 })
            } else {
              Image(this.viewModel.gauzePercent > 0.5 ?
                $r('app.media.curtain_icon_window_screening_right_part_open') :
                $r('app.media.curtain_icon_window_screening_right_part_closed'))
                .width('70%')
                .height(160)
                .objectFit(ImageFit.Cover)
                .position({ x: '30%', y: 0 })
                .translate({ x: this.viewModel.gauzePercent * 60 })
            }
          }
          .width('100%')
          .height(160)
          .clip(true)
        }
      }
      .width('100%')
      .height(160)
      .borderRadius(12)
      .clip(true)

      // 进度条
      Row() {
        Text('0%')
          .fontSize(12)
          .fontColor('#FFFFFF')
        Slider({
          value: isCloth ? this.viewModel.clothPercent * 100 : this.viewModel.gauzePercent * 100,
          min: 0,
          max: 100,
          style: SliderStyle.OutSet
        })
          .enabled(false)
          .layoutWeight(1)
          .margin({ left: 8, right: 8 })
        Text('100%')
          .fontSize(12)
          .fontColor('#FFFFFF')
      }
      .width('100%')
      .padding({ top: 12 })

      // 三个控制按钮
      Row({ space: 10 }) {
        this.ControlButton('打开', $r('app.media.curtain_icon_open'), isCloth ? 'cloth' : 'gauze', 'open')
        this.ControlButton('暂停', $r('app.media.curtain_icon_pause'), isCloth ? 'cloth' : 'gauze', 'pause')
        this.ControlButton('关闭', $r('app.media.curtain_icon_close'), isCloth ? 'cloth' : 'gauze', 'close')
      }
      .width('100%')
      .padding({ top: 12 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('rgba(17,27,58,0.9)')
    .borderRadius(24)
    .border({ width: 1, color: '#1F2C54' })
  }

  // 单个控制按钮
  @Builder
  ControlButton(label: string, icon: Resource, type: string, action: string) {
    Row() {
      Image(icon)
        .width(40)
        .height(40)
      Text(label)
        .fontSize(16)
        .fontColor(this.getHighlighted(type, action) ? '#D7C189' : '#FFFFFF')
        .margin({ left: 8 })
    }
    .width('31%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .borderRadius(8)
    .backgroundColor(this.getHighlighted(type, action) ? 'rgba(215, 193, 137, 0.15)' : 'rgba(255, 255, 255, 0.08)')
    .border({ width: 1, color: this.getHighlighted(type, action) ? '#D7C189' : '#404F7A' })
    .onClick(() => this.getClickHandler(type, action)())
  }

  // 获取按钮是否高亮
  private getHighlighted(type: string, action: string): boolean {
    // 只有选中了对应类型才显示高亮
    const selected = this.viewModel.selectedControl
    if (type === 'cloth') {
      // 暂停按钮：只在paused状态时高亮
      if (action === 'pause') {
        return this.viewModel.clothState === 'paused'
      }
      // cloth类型只在selectedControl为'cloth'时才可能高亮
      if (selected !== 'cloth') {
        return false
      }
      if (action === 'open') {
        return this.viewModel.clothState === 'opening' || this.viewModel.clothState === 'opened'
      } else {
        return this.viewModel.clothState === 'closing' || this.viewModel.clothState === 'closed'
      }
    } else {
      // 暂停按钮：只在paused状态时高亮
      if (action === 'pause') {
        return this.viewModel.gauzeState === 'paused'
      }
      // gauze类型只在selectedControl为'gauze'时才可能高亮
      if (selected !== 'gauze') {
        return false
      }
      if (action === 'open') {
        return this.viewModel.gauzeState === 'opening' || this.viewModel.gauzeState === 'opened'
      } else {
        return this.viewModel.gauzeState === 'closing' || this.viewModel.gauzeState === 'closed'
      }
    }
  }

  // 获取点击处理器
  private getClickHandler(type: string, action: string): () => void {
    if (type === 'cloth') {
      if (action === 'open') {
        return () => this.handleOpen(this.viewModel, 'cloth')
      } else if (action === 'pause') {
        return () => this.handlePause(this.viewModel, 'cloth')
      } else {
        return () => this.handleClose(this.viewModel, 'cloth')
      }
    } else {
      if (action === 'open') {
        return () => this.handleOpen(this.viewModel, 'gauze')
      } else if (action === 'pause') {
        return () => this.handlePause(this.viewModel, 'gauze')
      } else {
        return () => this.handleClose(this.viewModel, 'gauze')
      }
    }
  }
}
// 服务开关区域（请勿打扰+清理房间）
// 查拉图斯特拉如是说

import { ServiceToggleCard } from './ServiceToggleCard.ets'

@ComponentV2
export struct ServiceSwitchCard {
  @Param disturbMode: boolean = false
  @Param cleanRoom: boolean = false
  @Param onToggleDisturb: () => void = () => {}
  @Param onToggleClean: () => void = () => {}

  build() {
    Row({ space: 18 }) {
      ServiceToggleCard({
        icon: $r('app.media.service_icon_do_not_disturb'),
        title: '请勿打扰',
        isOn: this.disturbMode,
        onToggleHandler: this.onToggleDisturb
      })

      ServiceToggleCard({
        icon: $r('app.media.service_icon_clean_room'),
        title: '清理房间',
        isOn: this.cleanRoom,
        onToggleHandler: this.onToggleClean
      })
    }
  }
}
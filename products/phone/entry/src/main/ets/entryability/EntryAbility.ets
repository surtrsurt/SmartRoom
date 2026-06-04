import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { TokenStore } from 'common_datastore';
import { RoomStore } from 'common_datastore';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 设置全屏布局（沉浸模式）
    let windowClass: window.Window | null = null
    windowStage.getMainWindow().then((win) => {
      windowClass = win
      windowClass.setLayoutFullScreen(true)
      hilog.info(DOMAIN, 'testTag', 'Set full screen layout success')
    }).catch((err: Error) => {
      hilog.error(DOMAIN, 'testTag', 'Failed to set full screen layout: %{public}s', err.message)
    })

    // 初始化TokenStore
    TokenStore.getInstance().init(this.context)
    RoomStore.getInstance().init(this.context)

    // 始终加载MainPage，由MainPage内部判断登录状态
    windowStage.loadContent('pages/MainPage', (err) => {
      if (err) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}d', err);
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
// 灯光模型
// 查拉图斯特拉如是说

@ObservedV2
export class LightHardwareInfo {
  @Trace id: number = 0
  @Trace name: string = ''
  @Trace icon: string = ''
  @Trace on: boolean = false

  constructor(id: number, name: string, icon: string, on: boolean) {
    this.id = id
    this.name = name
    this.icon = icon
    this.on = on
  }
}

export interface LightControlRequest {
  scene?: number
  hardwareId?: number
  on?: boolean
}

// 场景模式与硬件ID对照表（根据接口文档）
export enum LightScene {
  NONE = 0,    // 总关模式 103004
  BRIGHT = 1,  // 明亮模式 103001
  SOFT = 2,    // 柔和模式 103002
  READ = 3,    // 阅读模式 103003
  WARM = 4,    // 温馨模式 103004
  SLEEP = 5    // 睡眠模式 103005
}

// 场景模式对应的硬件ID
export const SCENE_HARDWARE_IDS: Record<number, number> = {
  0: 103004,  // 总关模式
  1: 103001,  // 明亮模式
  2: 103002,  // 柔和模式
  3: 103003,  // 阅读模式
  4: 103004,  // 温馨模式
  5: 103005   // 睡眠模式
}

// 独立控制硬件ID对照表（根据接口文档中的lights数组）
export const HARDWARE_ID_MAP: Record<string, number> = {
  '洗漱间': 103125,
  '衣柜灯': 103128,
  '落地灯': 103129,
  '吧台灯': 103130,
  '书桌灯': 103131,
  '右阅读灯': 103132,
  '左阅读灯': 103133,
  '排风扇': 103134,
  '廊灯': 103135
}

// 场景模式对应的独立控制状态（key为场景数字值）
export const SCENE_HARDWARE_STATES: Record<number, Record<string, boolean>> = {
  // 明亮模式(1)：全部打开
  1: {
    '洗漱间': true,
    '衣柜灯': true,
    '落地灯': true,
    '吧台灯': true,
    '书桌灯': true,
    '左阅读灯': true,
    '右阅读灯': true,
    '排风扇': true,
    '廊灯': true
  },
  // 柔和模式(2)：全部打开
  2: {
    '洗漱间': true,
    '衣柜灯': true,
    '落地灯': true,
    '吧台灯': true,
    '书桌灯': true,
    '左阅读灯': true,
    '右阅读灯': true,
    '排风扇': true,
    '廊灯': true
  },
  // 阅读模式(3)：只开书桌灯和阅读灯
  3: {
    '洗漱间': false,
    '衣柜灯': false,
    '落地灯': false,
    '吧台灯': false,
    '书桌灯': true,
    '左阅读灯': true,
    '右阅读灯': true,
    '排风扇': false,
    '廊灯': false
  },
  // 温馨模式(4)：全部打开
  4: {
    '洗漱间': true,
    '衣柜灯': true,
    '落地灯': true,
    '吧台灯': true,
    '书桌灯': true,
    '左阅读灯': true,
    '右阅读灯': true,
    '排风扇': true,
    '廊灯': true
  },
  // 入睡模式(5)：全部关闭
  5: {
    '洗漱间': false,
    '衣柜灯': false,
    '落地灯': false,
    '吧台灯': false,
    '书桌灯': false,
    '左阅读灯': false,
    '右阅读灯': false,
    '排风扇': false,
    '廊灯': false
  },
  // 总关模式(0)：全部关闭
  0: {
    '洗漱间': false,
    '衣柜灯': false,
    '落地灯': false,
    '吧台灯': false,
    '书桌灯': false,
    '左阅读灯': false,
    '右阅读灯': false,
    '排风扇': false,
    '廊灯': false
  }
}
# SmartRoom - HarmonyOS智慧客房应用

基于HarmonyOS的智慧酒店客房控制系统，支持手机、平板和折叠屏设备。

## 技术栈

- **框架**: HarmonyOS + ArkTS
- **架构**: MVVM + V2状态管理
- **版本**: SDK 6.1.0 (API 23)

## 功能模块

| 模块 | 说明 |
|------|------|
| 登录 | 房间号+姓名认证，Token持久化 |
| 首页 | 仪表盘、场景模式、空调卡片、夜灯 |
| 灯光 | 场景模式+独立控制，与首页同步 |
| 窗帘 | 布帘+窗纱控制，支持动画暂停 |
| 服务 | 请勿打扰、清理房间、SOS、天气 |

## 构建命令

```bash
# Debug编译
hvigor --build-mode debug assembleApp

# Release编译
hvigor --build-mode release assembleApp

# 清理构建
hvigor clean
```

## 项目结构（三层架构）

```
SmartRoom/
├─ common/                    # 公共能力库（type: har）
│   ├─ network/             # HTTP请求 + 天气API
│   ├─ datastore/           # Preferences存储（Token/Room/LightScene/Service）
│   ├─ mock/                # Mock数据服务
│   ├─ uicomponents/        # ToastUtils、LoadingDialog
│   ├─ utils/               # Logger、ValidateUtils、DateUtils
│   └─ weather/             # 天气服务（高德API + 300+城市）
│
├─ features/                 # 业务模块（type: har）
│   ├─ login/               # 登录模块
│   ├─ home/                # 首页（仪表盘）
│   ├─ light/               # 灯光控制
│   ├─ air/                 # 空调组件（AirConditionerCard）
│   ├─ curtain/             # 窗帘控制
│   └─ service/             # 服务模块（+天气卡片）
│
└─ products/phone/entry/      # 产品入口（type: entry）
    └─ pages/               # MainPage（TabBar）、LoginPage
```

## 状态管理

- **V2装饰器**: `@ObservedV2` + `@Trace`
- **共享状态单例**:
  - `TokenStore`: 登录token管理
  - `RoomStore`: 客房状态（灯光/空调/窗帘）
  - `LightSceneStore`: 灯光场景同步
  - `ServiceStore`: 请勿打扰/清理房间同步

## API配置

- 基础URL: `https://ohosiot.admitpro.cn`
- 认证: Bearer Token
- 天气API: 高德地图 (`restapi.amap.com`)

## 模块入口（无Index.ets）

| 模块 | main入口文件 |
|------|-------------|
| features_login | view/LoginPage.ets |
| features_home | view/HomePage.ets |
| features_light | view/LightPage.ets |
| features_curtain | view/CurtainPage.ets |
| features_service | view/ServicePage.ets |
| features_air | view/AirPage.ets |
| common_datastore | TokenStore.ets |
| common_network | ApiConfig.ets |
| common_weather | api/WeatherService.ets |
| common_mock | login/MockLoginService.ets |
| common_uicomponents | ToastUtils.ets |
| common_utils | Logger.ets |
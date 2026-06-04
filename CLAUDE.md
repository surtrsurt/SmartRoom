# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在本项目中的操作指南。

## 项目概述

HarmonyOS智慧客房应用 (SmartRoom) - 支持手机、平板和折叠屏设备的智能酒店客房控制系统。

## 构建命令

```bash
# Debug编译（从项目根目录）
hvigor --build-mode debug assembleApp

# Release编译
hvigor --build-mode release assembleApp

# 清理构建
hvigor clean
```

## SDK与环境

- **HarmonyOS SDK:** 6.1.0 (API version 23)
- **ArkTS 严格模式:** 启用（无隐式any，无对象字面量作为类型）
- **注意:** ViewModel类使用普通类，不使用@ObservedV2，因为@State无法持有@ObservedV2类

## 架构

### 模块结构（三层架构）

```
products/phone/entry/     # 入口应用模块（type: entry）
common/                   # 公共能力库（type: har）
  ├── network/           # HTTP请求 + 天气API
  ├── datastore/        # Preferences + AppStorage持久化
  ├── mock/            # Mock数据与类型
  ├── uicomponents/    # 可复用UI组件（ToastUtils等）
  ├── utils/            # ValidateUtils、Logger等
  └── weather/          # 天气服务（高德API + 300+城市）
features/               # 业务功能模块（type: har）
  ├── login/            # 登录认证
  ├── home/            # 首页仪表盘
  ├── light/           # 灯光控制
  ├── air/             # 空调（提供AirConditionerCard组件）
  ├── curtain/        # 窗帘控制
  └── service/         # 客服服务 + 天气卡片
```

### 状态管理

使用 `@ObservedV2` 和 `@Trace` 装饰器的V2状态管理。

**单例Store：**
- `TokenStore`: 登录token、roomNo、firstName、loginTime（24小时有效期）
- `RoomStore`: 客房状态（灯光/空调/窗帘）
- `LightSceneStore`: 灯光场景同步与监听器
- `ServiceStore`: 请勿打扰与清理房间同步及监听器

**用法：**
```typescript
TokenStore.getInstance().getToken()
ServiceStore.getInstance().setDisturbMode(true)
```

### 已应用的关键修复

1. **ApiResponse** - 在每个Mock/Repository文件中本地定义，避免跨模块导入
2. **AppStorageV2** - 不使用set/get/delete方法，使用TokenStore单例替代
3. **结构化类型** - 使用特定属性访问而非对象比较
4. **对象字面量** - 必须有对应的interface/class声明
5. **this引用** - 使用类方法而非带this的独立函数
6. **@Event装饰器** - 仅在@ComponentV2使用，@Component页面使用回调参数

### API配置

基础URL: `https://ohosiot.admitpro.cn`
认证: Authorization头中的Bearer Token
天气API: `https://restapi.amap.com/v3`（高德地图）

### 导航

页面定义在 `resources/base/profile/main_pages.json`：
- `pages/LoginPage` - 认证页面
- `pages/MainPage` - 设备控制仪表盘（TabBar容器）

### MVVM模式（按功能模块）

每个功能模块遵循：
```
view/       # .ets页面组件
viewmodel/  # @ObservedV2状态持有者
model/      # 数据模型与类型
repository/ # 数据访问层
api/        # 网络API调用
```

### 模块入口（无Index.ets）

| 模块 | main入口 |
|------|---------|
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

### 跨模块类型导出

| 类型 | 定义位置 | 导出位置 |
|------|---------|---------|
| LightState | RoomStore.ets | common_datastore |
| HardwareItem | RoomStore.ets | common_datastore |
| AirState | RoomStore.ets | common_datastore |
| CurtainState | RoomStore.ets | common_datastore |
| WeatherData | WeatherModel.ets | common_weather |
| CityInfo | WeatherModel.ets | common_weather |
| WeatherCondition | WeatherModel.ets | common_weather |
| RainDrop | WeatherModel.ets | common_weather |
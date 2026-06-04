# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

HarmonyOS智慧客房应用 (SmartRoom) - A smart hotel room control application supporting phone, tablet, and foldable devices.

## Build Commands

```bash
# Build debug APK (from project root)
hvigor --build-mode debug assembleApp

# Build release APK
hvigor --build-mode release assembleApp

# Clean build
hvigor clean
```

## SDK & Environment

- **HarmonyOS SDK:** 6.1.0 (API version 23)
- **ArkTS Strict Mode:** Enabled (no implicit any, no obj literals as types)
- **Note:** ViewModel classes use plain class without @ObservedV2 since @State cannot hold @ObservedV2 classes

## Architecture

### Module Structure (Three-Layer)

```
products/phone/entry/     # Entry application module (type: entry)
common/                   # Shared capability libraries (type: har)
  ├── network/           # HTTP requests + 天气API
  ├── datastore/        # Preferences + AppStorage persistence
  ├── mock/            # Mock data and types
  ├── uicomponents/    # Reusable UI components (ToastUtils, etc.)
  ├── utils/            # ValidateUtils, Logger, etc.
  └── weather/          # Weather service (高德API + 300+ cities)
features/               # Business feature modules (type: har)
  ├── login/            # Authentication
  ├── home/            # Dashboard
  ├── light/           # Lighting control
  ├── air/             # Air conditioning (provides AirConditionerCard component)
  ├── curtain/        # Curtain control
  └── service/         # Guest services + weather card
```

### State Management

V2 state management using `@ObservedV2` and `@Trace` decorators on ViewModel classes.

**Singleton Stores:**
- `TokenStore`: Login token, roomNo, firstName, loginTime (24h validity)
- `RoomStore`: Room state (light/air/curtain)
- `LightSceneStore`: Light scene sync with listeners
- `ServiceStore`: Disturb mode & clean room sync with listeners

**Usage:**
```typescript
TokenStore.getInstance().getToken()
ServiceStore.getInstance().setDisturbMode(true)
```

### Key Fixes Applied

1. **ApiResponse** - Define locally in each Mock/Repository file, avoid cross-module import
2. **AppStorageV2** - Don't use set/get/delete methods, use TokenStore singleton instead
3. **Structured Types** - Use specific property access instead of object comparison
4. **Object Literals** - Must have corresponding interface/class declaration
5. **this Reference** - Use class methods instead of standalone functions with this
6. **@Event Decorator** - Only use with @ComponentV2, use callback parameters for @Component pages

### API Configuration

Base URL: `https://ohosiot.admitpro.cn`
Authentication: Bearer Token in Authorization header
Weather API: `https://restapi.amap.com/v3` (高德地图)

### Navigation

Pages defined in `resources/base/profile/main_pages.json`:
- `pages/LoginPage` - Authentication screen
- `pages/MainPage` - Device control dashboard (TabBar container)

### MVVM Pattern per Feature Module

Each feature follows:
```
view/       # .ets page components
viewmodel/  # @ObservedV2 state holders
model/      # Data models and types
repository/ # Data access layer
api/        # Network API calls
```

### Module Entry Points (No Index.ets)

| Module | main entry |
|--------|-----------|
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

### Cross-Module Type Exports

| Type | Definition | Export Location |
|------|-----------|-----------------|
| LightState | RoomStore.ets | common_datastore |
| HardwareItem | RoomStore.ets | common_datastore |
| AirState | RoomStore.ets | common_datastore |
| CurtainState | RoomStore.ets | common_datastore |
| WeatherData | WeatherModel.ets | common_weather |
| CityInfo | WeatherModel.ets | common_weather |
| WeatherCondition | WeatherModel.ets | common_weather |
| RainDrop | WeatherModel.ets | common_weather |
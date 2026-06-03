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

### Module Structure

```
products/phone/entry/     # Entry application module (type: entry)
common/                   # Shared capability libraries (type: har)
  ├── network/           # HTTP requests
  ├── datastore/         # Preferences + AppStorage persistence
  ├── mock/             # Mock data and types
  ├── uicomponents/     # Reusable UI components (ToastUtils, etc.)
  └── utils/            # ValidateUtils, Logger, etc.
features/                 # Business feature modules (type: har)
  ├── login/            # Authentication
  ├── home/             # Dashboard
  ├── light/            # Lighting control
  ├── air/              # Air conditioning
  ├── curtain/         # Curtain control
  └── service/          # Guest services
```

### State Management

V2 state management using `@ObservedV2` and `@Trace` decorators on ViewModel classes. Login state persisted via `TokenStore` singleton (Preferences-based):
- `TokenStore`: `token`, `roomNo`, `firstName`, `loginTime`
- `TokenStore.getInstance().getToken()` / `getRoomNo()` / `getFirstName()`
- `TokenStore.getInstance().setToken()` / `clearToken()`
- Token validity: 24 hours (checked via `isTokenExpired()`)

### Key Fixes Applied

1. **ApiResponse** - 在每个Mock和Repository文件中本地定义，避免跨模块导入
2. **AppStorageV2** - 不使用 set/get/delete 方法，改用 TokenStore 单例模式
3. **结构化类型** - 避免对象属性直接比较，使用具体属性访问
4. **对象字面量** - 必须有对应的 interface/class 声明
5. **this引用** - 使用类方法替代独立函数中的this
6. **@Event装饰器** - 仅配合 @ComponentV2 使用，@Component 页面用回调参数

### API Configuration

Base URL: `https://ohosiot.admitpro.cn`
Authentication: Bearer Token in Authorization header

### Navigation

Pages defined in `resources/base/profile/main_pages.json`:
- `pages/LoginPage` - Authentication screen
- `pages/MainPage` - Device control dashboard

### MVVM Pattern per Feature Module

Each feature follows:
```
view/    # .ets page components
viewmodel/  # @ObservedV2 state holders
model/   # Data models and types
repository/  # Data access layer
api/     # Network API calls
```
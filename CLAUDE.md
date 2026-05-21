# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

HarmonyOS 智慧客房 App，基于 ArkUI 开发，MVVM 架构 + V2状态管理装饰器 + Navigation导航架构。

## 常用命令

```bash
# 构建项目
hvigor -p module=entry@default -p product=default assembleHap

# 清理构建
hvigor clean -p module=entry@default
```

## 项目架构

```
entry/src/main/ets/
├── AppStartup.ets              # 启动时检查token和记住我状态
├── common/helper/              # 公共工具层
│   └── PreferencesHelper.ets  # preferences封装
├── features/                   # 功能模块层（按业务划分）
│   └── login/
│       ├── components/         # UI组件
│       ├── model/              # 数据模型+Mock接口
│       └── viewmodel/          # 状态管理
└── pages/                      # 页面层（路由入口）
```

**三层架构原则**：common层放公共工具，features层放业务模块，pages层放页面入口。

## ArkTS 约束

- 禁止使用 `any`/`unknown`，必须显式声明类型
- 导出类使用 `export class`，导入时用 `{ ClassName }`
- Text/Button 设置文字颜色用 `fontColor()`，不是 `color()`
- Button 没有 `font` 属性，设置文字用其他方式
- `router.pushUrl` 已废弃，需处理异常
- `promptAction.showToast` 已废弃

## 重要配置

- `main_pages.json` 配置页面路由，LoginPage 放在首位
- EntryAbility 通过 AppStartup 初始化，检查 token 决定跳转页面
- 媒体资源放在 `resources/base/media/`

## 用户偏好

- 每条回复末尾添加: "查拉图斯特拉如是说"
# SmartRoom - HarmonyOS智慧客房应用

基于HarmonyOS的智慧酒店客房控制系统，支持手机、平板和折叠屏设备。

## 技术栈

- **框架**: HarmonyOS + ArkTS
- **架构**: MVVM + V2状态管理
- **版本**: SDK 6.1.0 (API 23)

## 功能模块

- 登录认证
- 首页仪表盘
- 灯光控制
- 空调控制
- 窗帘控制
- 客服务

## 构建

```bash
hvigor --build-mode debug assembleApp
```

## 项目结构

```
common/        # 公共能力库（网络、存储、UI组件）
features/      # 业务功能模块
products/      # 产品入口
```

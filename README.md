# Bullet Train

可回复弹幕的原型，目前主页面自动生成彩色弹幕。

## 使用者需要注意

配对正式 **Calcit / @calcit/procs 0.38.0**、Caps 0.1.1、Node 24、Yarn 4.18.0，模块使用正式 Reel 0.11.0、Respo 0.19.5、UI 0.15.2 和 JS FFI 0.2.13。传递 Router 0.12.2。升级后重装完整依赖图、重新生成 JS、重启并刷新，不混用旧 runtime。

弹幕内容、位置、播放进度、裁剪阈值及 `/videos/diandian.mov` 地址保持。仓库没有原视频，页面会显示媒体无法播放；不能把弹幕可见等同视频播放通过。原 footer/progress 没有在主页面挂载，本轮不增加界面功能。

原存储键及 Store 的 EDN 序列化保持，入口仍只写入存档，刷新重新启动自动弹幕，不新增存档读取或恢复。`hud!` 仍由 JS 提供页面成功/编译错误提示，不用 raise 或控制台日志替代。

## 本次迁移与风险

应用事件和回放控制用 `Op | reel.typed/Control` 区分。渲染入口接收具体 Op，Reel 面板和键盘通过独立回调接收具体 Control。组件状态路径使用 CoordKey，Store 和 Reel 在内部保留具名类型。

## 开发与验证

```sh
caps --ci --strict
yarn install --immutable
caps verify --toolchain
calcit calcit.cirru --check-only --all-defs
calcit calcit.cirru fix --workflow strict --verify
yarn build
node --test scripts/bullet-regression.test.mjs
```

`yarn dev` 编译一次后启动 Vite；源码监听另开终端运行 `calcit calcit.cirru js -w`。

仅维护 `calcit.cirru` / `deps.cirru`，Snapshot 使用官方 CLI；不恢复 compact.cirru/package.cirru，不提交 js-out/dist，不增加常驻验证脚本。

## 前端部署

设置 VITE_BASE_URL 控制 CDN 前缀。COS 只上传 dist/，精确正式 cos-upload-action v1.2.0 内置 HTML 引用及公开内容校验，不复制额外 verify 脚本。PR 沿用独立编号/run/attempt 前缀；原 `/web-assets/repo/Memkits/bullet-train` 目的地和 main-only rsync 保持，不迁移视频或后端。

模板：[respo-calcit-workflow](https://github.com/calcit-lang/respo-calcit-workflow)。

## License

MIT

# Bullet Train

可回复弹幕的原型，目前主页面自动生成彩色弹幕。

## 使用者需要注意

配对正式 **Calcit / @calcit/procs 0.32.1**、Caps 0.1.1、Node 24、Yarn 4.18.0，模块使用正式 Reel 0.7.0、Respo 0.17.1、UI 0.9.0 和 JS FFI 0.2.9。UI 自身的 Router 0.9.0-alpha.4 传递依赖保留，不引用 main/hash。升级后重装完整依赖图、重新生成 JS、重启并刷新，不混用旧 runtime。

弹幕内容、位置、播放进度、裁剪阈值及 `/videos/diandian.mov` 地址保持。仓库没有原视频，页面会显示媒体无法播放；不能把弹幕可见等同视频播放通过。原 footer/progress 没有在主页面挂载，本轮不增加界面功能。

原存储键及 Map 格式保持，入口仍只写入存档，刷新重新启动自动弹幕，不新增存档读取或恢复。`hud!` 仍由 JS 提供页面成功/编译错误提示，不用 raise 或控制台日志替代。

## 本次迁移与风险

官方 formatter 转换三处旧类型形式。34个既有完整官方视图中，仅 render-app! 的渲染回调代码变化，既有 schema/tests/meta 不变；新增开放 Enum 的 DispatchOp 代表定义以绑定入口类型槽，代表值不发送。

渲染回调明确接收 Enum 后交给原 dispatch-wire!。原入口继续先区分 Reel 控制，再将业务操作解码成名义 Op；业务 dispatch! 仍只接受应用 Op，DevTools 仍经过原 Dynamic 边界。没有把匿名控制操作伪装成业务 Op，也没有取消运行时检查、增加事件包装或改变 updater。

依赖、runtime 和 lock 配对，一小时 npm 包龄无单包例外；原 CI、权限、精确正式 Action tags、COS verify 和部署路径不改。开放 Reel/wire 边界仍有真实 Dynamic，不宣称债务清零，不增加类型预算、强转或编译器 fix/proof 规则。

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

候选通过230个全定义、完整 strict diagnostics=[]、原7项 JS回归及构建；原测试文件/断言保持，没有附带 native 测试，不以空集合计为通过。实际隔离页面验证彩色自动弹幕和刷新后重新启动；媒体文件缺失，未验收视频播放、未挂载 footer 的页面交互、存档恢复或热更新 HUD 注错。不用历史0.30.1证据代替本轮验收。

`yarn dev` 编译一次后启动 Vite；源码监听另开终端运行 `calcit calcit.cirru js -w`，不添加 concurrently。按照维护者已允许本地使用新工具链的要求，本轮可用官方固定0.32.1执行 query/tree/edit、检查和构建；不再沿用早期仅 Linux 准备 CI 的临时限制。

仅维护 `calcit.cirru` / `deps.cirru`，Snapshot 使用官方 CLI；不恢复 compact.cirru/package.cirru，不提交 js-out/dist，不增加常驻验证脚本。

## 前端部署

设置 VITE_BASE_URL 控制 CDN 前缀。COS 只上传 dist/，精确正式 cos-upload-action v1.2.0 内置 HTML 引用及公开内容校验，不复制额外 verify 脚本。PR 沿用独立编号/run/attempt 前缀；原 `/web-assets/repo/Memkits/bullet-train` 目的地和 main-only rsync 保持，不迁移视频或后端。

模板：[respo-calcit-workflow](https://github.com/calcit-lang/respo-calcit-workflow)。

## License

MIT

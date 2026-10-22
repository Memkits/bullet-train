
Bullet(Screen) train
----

> a prototype, if bullet screen can be replied

Demo _TODO_ .

使用配对的正式 Calcit/procs **0.30.1**、Caps 0.1.1、Node.js 24 和 Yarn 4.18.0。
模块使用正式 Reel 0.6.41、Respo 0.16.124、UI 0.8.0 和 js-ffi 0.2.5；
不修改已迁移的应用源码、公开操作或存档格式，仍只写入存档、不新增恢复行为。

播放进度、弹幕内容/位置、裁剪规则和 `/videos/diandian.mov` 地址保持不变。
入口继续生成自动弹幕；原有 footer/progress 组件没有在主界面挂载，本轮不新增界面功能。
Store 在 Reel 边界做名义检查，操作通过已有具名 Op 的实际解码进入 updater；
不在每个 tick 递归重建弹幕列表。DOM 和 prompt 使用模块已发布接口，移除两处 unsafe。
原持久化格式不变；原入口只有写入存档，本轮不新增读取/恢复行为。

```sh
caps --ci --strict
yarn install --immutable
caps verify --toolchain
calcit calcit.cirru --check-only --all-defs
calcit calcit.cirru fix --workflow strict --verify
yarn build
node --test scripts/bullet-regression.test.mjs
```

The canonical project files are
`calcit.cirru` and `deps.cirru`; CI rejects retired `compact.cirru` and
`package.cirru` snapshots. Runtime regressions are checked with
`node --test scripts/bullet-regression.test.mjs` after code generation.
保留现有 7 项业务回归，通过真实 Reel wire adapter 回放操作，子节点遍历适配到
Respo 的 ChildPair/RenderNode；不修改原业务断言或增加检查脚本。

开放状态和 wire 输入仍有显式 Dynamic，不宣称类型债务清零。本地媒体文件未随仓库提供，
没有原视频时只能验收自动弹幕和交互逻辑，不能据此宣称视频播放通过。
移除未被工作流引用的旧 quality 预算文件：其中仍有已删除的 `app.schema/Reel`
和两处已移除 unsafe 的额度。保留全部定义检查、完整 strict 与原 7 项测试，
不依赖已退役的 `analyze quality`；strict 报告中四个实际 Reel/wire 边界仍逐项列出。

Only generated frontend assets are uploaded to COS. cos-upload-action handles
HTML reference and public verification with the released v1.2.0 action’s built-in verify settings. Existing video and server
deployment paths are unchanged. Each PR uses an isolated
`pr/<number>/<run-id>/<attempt>/` CDN prefix; path selection stays in the workflow
without extra CDN checker scripts.

Use `yarn build` to compile once and build Vite with `VITE_BASE_URL` (relative
URLs by default). `yarn dev` compiles once before starting Vite; for live Calcit
edits, run `calcit calcit.cirru -w` in another terminal. No extra process
manager is needed.

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT

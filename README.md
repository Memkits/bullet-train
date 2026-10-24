
Bullet(Screen) train
----

> a prototype, if bullet screen can be replied

Demo _TODO_ .

使用配对的正式 Calcit/procs **0.30.1**、Caps 0.1.1、Node.js 24 和 Yarn 4.18.0。
模块升级为正式 Reel 0.6.42、Respo 0.16.126、UI 0.8.1 和 js-ffi 0.2.6；
保留公开业务操作和存档格式，仍只写入存档、不新增恢复行为。
修复开发态 Reel 操作入口：快捷键和面板的 `:reel/*` 操作交给 Reel 自身处理，
业务操作才解码成应用的具名 `Op`，避免把两种不同的枚举身份混为一谈。

本轮继续迁移源码旧 Option/Map 调用和真实弹幕 List 的 count→`.len`，去掉一次单参数
merge，保留原顺序、默认值和裁剪阈值。叠层样式使用等价 `absolute` / `-10` String，
匹配已发布 UI 的 String Map；z-index 是无单位属性，不增加 px。原内联值类型改变，
CSS 表现目标不变，不通过放宽类型或强转绕过检查。
Vite 升级 8.3.3；其他 npm 依赖不变，移除包预批准、不添加新安装例外。
真实 `hud!` 成功/错误路径保留，不改成 raise。原 7 项业务断言不改，不新增永久检查脚本、
测试框架、预算或 concurrently。正式 CI 和实际页面仍需独立验收，版本声明不等于完成。
源码仅由官方 Linux 0.30.1 的结构化事务生成；本地不执行 Caps 或编译器 check/build/
codegen/Snapshot 写入，只读 query/tree 与跳过脚本的 Yarn 锁文件更新允许。

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
edits, run `calcit calcit.cirru js -w` in another terminal. No extra process
manager is needed.

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT


Bullet(Screen) train
----

> a prototype, if bullet screen can be replied

Demo _TODO_ .

Use Calcit 0.27.0 and `caps --ci --strict`. The canonical project files are
`calcit.cirru` and `deps.cirru`; CI rejects retired `compact.cirru` and
`package.cirru` snapshots. Runtime regressions are checked with
`node --test scripts/*.test.mjs` after code generation.

Only generated frontend assets are uploaded to COS. cos-upload-action handles
public verification with its built-in verify settings. Existing video and server
deployment paths are unchanged.

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT

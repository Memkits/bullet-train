import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { test } from "node:test";
import { selectCdnPath } from "./cdn-path.mjs";

const common = { origin: "https://cos-sh.tiye.me", repository: "Memkits/bullet-train" };

test("PR builds use a path isolated by PR number", () => {
  const path = selectCdnPath({ ...common, eventName: "pull_request", prNumber: 12 });
  assert.deepEqual(path, {
    prefix: "Memkits/bullet-train/pr/12/",
    baseUrl: "https://cos-sh.tiye.me/Memkits/bullet-train/pr/12/",
  });
  assert.throws(() => selectCdnPath({ ...common, eventName: "pull_request" }), /PR number/);
});

test("main and branch builds use their respective CDN paths", () => {
  assert.deepEqual(selectCdnPath({ ...common, eventName: "push", ref: "refs/heads/main" }), {
    prefix: "Memkits/bullet-train/",
    baseUrl: "https://cos-sh.tiye.me/Memkits/bullet-train/",
  });
  assert.deepEqual(selectCdnPath({ ...common, eventName: "push", ref: "refs/heads/feature", refName: "feature" }), {
    prefix: "Memkits/bullet-train/branches/feature/",
    baseUrl: "https://cos-sh.tiye.me/Memkits/bullet-train/branches/feature/",
  });
});

test("built HTML references JS and CSS at the configured CDN base", () => {
  const baseUrl = process.env.VITE_BASE_URL;
  assert.ok(baseUrl, "Build with VITE_BASE_URL before running CDN tests");
  const html = readFileSync(new URL("../dist/index.html", import.meta.url), "utf8");
  const script = html.match(/<script[^>]+src="([^"]+)"/);
  const stylesheet = html.match(/<link[^>]+rel="stylesheet"[^>]+href="([^"]+\/assets\/[^\"]+\.css)"/);
  assert.ok(script, "built HTML has a script");
  assert.ok(stylesheet, "built HTML has a generated stylesheet");
  for (const url of [script[1], stylesheet[1]]) {
    assert.ok(url.startsWith(`${baseUrl}assets/`), `${url} must use ${baseUrl}`);
  }
});

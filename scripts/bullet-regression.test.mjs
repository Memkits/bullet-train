import assert from "node:assert/strict";
import { test } from "node:test";
import * as c from "../js-out/calcit.core.mjs";
import { store, Op } from "../js-out/app.schema.mjs";
import { updater } from "../js-out/app.updater.mjs";
import { video_length } from "../js-out/app.config.mjs";
import { comp_bullet, comp_progress, comp_container, comp_footer } from "../js-out/app.comp.container.mjs";
import { reel } from "../js-out/reel.schema.mjs";
import { make_string } from "../js-out/respo.render.html.mjs";
import { component_$q_, component_tree } from "../js-out/respo.util.detect.mjs";

const t = c.init_tags(["progress", "playing?", "bullets", "content", "color", "rand", "states", "root", "data", "store", "base", "event", "children", "click", "toggle", "restart"]);
const field = (v, k) => c.option_$o_unwrap(c.get(v, k));
const nth = (v, i) => c.option_$o_unwrap(c.nth(v, i));
const apply = (v, name, ...args) => updater(v, c._PCT__$o__$o_(Op, c.init_tags([name])[name], ...args), "test", 0);

test("tick advances progress and stops exactly at the video duration", () => {
  let next = apply(store, "tick", 100);
  assert.equal(field(next, t.progress), 100);
  next = apply(next, "tick", video_length);
  assert.equal(field(next, t.progress), video_length);
  assert.equal(field(next, t["playing?"]), false);
});
test("toggle and restart preserve bullets while resetting playback", () => {
  const original = apply(store, "bullet", "kept", 0.5, "white");
  const paused = apply(original, "toggle");
  assert.equal(field(paused, t["playing?"]), false);
  const restarted = apply(apply(paused, "tick", 100), "restart");
  assert.equal(field(restarted, t.progress), 0);
  assert.equal(field(restarted, t["playing?"]), true);
  assert.ok(c._$e_(field(restarted, t.bullets), field(original, t.bullets)));
});
test("new bullets capture current progress, text, random position and color", () => {
  const next = apply(apply(store, "tick", 123), "bullet", "fixture", 0.25, "yellow");
  const bullet = nth(field(next, t.bullets), 0);
  for (const [key, expected] of [["progress", 123], ["content", "fixture"], ["rand", 0.25], ["color", "yellow"]]) assert.equal(field(bullet, t[key]), expected);
});
test("bullet history trims old entries without losing latest content", () => {
  let next = store;
  for (let i = 0; i < 802; i++) next = apply(next, "bullet", String(i), 0.5, "white");
  const bullets = field(next, t.bullets);
  assert.equal(c.count(bullets), 202);
  assert.equal(field(nth(bullets, 0), t.content), "600");
  assert.equal(field(nth(bullets, 201), t.content), "801");
});
test("nested state updates preserve playback and bullet data", () => {
  const original = apply(store, "bullet", "kept", 0.5, "white");
  const next = apply(original, "states", c._$L_(t.root), "nested");
  assert.equal(field(field(field(next, t.states), t.root), t.data), "nested");
  assert.equal(field(next, t.progress), 0);
  assert.ok(c._$e_(field(next, t.bullets), field(original, t.bullets)));
});
test("generated components render bullets, progress and the original video URL", () => {
  assert.match(make_string(comp_bullet("fixture", "yellow")), /fixture/);
  assert.match(make_string(comp_progress(video_length / 2)), /width:50%/);
  const originalWindow = globalThis.window;
  globalThis.window = { innerWidth: 1024, innerHeight: 768 };
  try {
    const next = apply(store, "bullet", "rendered", 0.5, "white");
    const html = make_string(comp_container(c.assoc(c.assoc(reel, t.base, next), t.store, next)));
    assert.match(html, /rendered/);
    assert.match(html, /src="\/videos\/diandian.mov"/);
  } finally { globalThis.window = originalWindow; }
});

function findClick(node, label) {
  if (component_$q_(node)) return findClick(c.option_$o_unwrap(component_tree(node)), label);
  const event = c.get(node, t.event);
  if (c.option_$o_some_$q_(event) && make_string(node).includes(label)) {
    const fn = c.get(c.option_$o_unwrap(event), t.click);
    if (c.option_$o_some_$q_(fn)) return c.option_$o_unwrap(fn);
  }
  const children = c.get(node, t.children);
  if (c.option_$o_some_$q_(children)) {
    for (const pair of c.option_$o_unwrap(children).toArray()) {
      const found = findClick(nth(pair, 1), label);
      if (found) return found;
    }
  }
}
test("footer callbacks dispatch single typed playback operations", () => {
  for (const [label, tag] of [["开始/暂停", t.toggle], ["重新开始", t.restart]]) {
    const fn = findClick(comp_footer(), label);
    assert.equal(typeof fn, "function");
    fn(null, (...args) => {
      assert.equal(args.length, 1);
      assert.equal(c._$n_enum_$o_nth(args[0], 0), tag);
    });
  }
});

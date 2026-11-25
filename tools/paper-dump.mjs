// Writes each artboard of a public Paper file to a folder: its HTML and a 2x screenshot.
// Paper draws an artboard as DOM with inline styles, so the HTML has the design's exact values.
// Use it when no Paper MCP server is available. Then read an artboard with tools/paper-tree.py.
//
//   bun tools/paper-dump.mjs <chrome-headless-shell> <empty profile dir> <out dir> <paper file URL>
//
// A headless Chromium is in ~/Library/Caches/ms-playwright after `bunx playwright install chromium`.
import { spawn } from 'node:child_process';
import { writeFileSync } from 'node:fs';
const [bin, profile, out, url] = process.argv.slice(2);
const port = 9347;
const chrome = spawn(bin, [`--remote-debugging-port=${port}`, `--user-data-dir=${profile}`, '--window-size=1600,1000', '--hide-scrollbars', 'about:blank'], { stdio: 'ignore' });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
let list;
for (let i = 0; i < 50; i++) { try { list = await (await fetch(`http://127.0.0.1:${port}/json`)).json(); break; } catch { await sleep(200); } }
const page = list.find((t) => t.type === 'page');
const ws = new WebSocket(page.webSocketDebuggerUrl);
await new Promise((r) => (ws.onopen = r));
let id = 0; const waits = new Map();
ws.onmessage = (m) => { const d = JSON.parse(m.data); if (d.id && waits.has(d.id)) { waits.get(d.id)(d); waits.delete(d.id); } };
const send = (method, params = {}) => new Promise((r) => { const i = ++id; waits.set(i, r); ws.send(JSON.stringify({ id: i, method, params })); });
const evaluate = async (expression) => { const r = await send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true }); if (r.result?.exceptionDetails) throw Error(JSON.stringify(r.result.exceptionDetails).slice(0, 500)); return r.result?.result?.value; };
await send('Page.enable');
await send('Emulation.setDeviceMetricsOverride', { width: 1600, height: 1000, deviceScaleFactor: 1, mobile: false });
await send('Page.navigate', { url });
for (let i = 0; i < 80; i++) { await sleep(500); if (await evaluate(`document.querySelectorAll('.paper-camera > [data-node-id]').length`) >= 21) break; }
await sleep(3000);
const boards = await evaluate(`[...document.querySelectorAll('.paper-camera > [data-node-id]')].map(c => ({id: c.getAttribute('data-node-id'), w: c.offsetWidth, h: c.offsetHeight, left: c.style.left, top: c.style.top, html: c.outerHTML}))`);
writeFileSync(`${out}/index.json`, JSON.stringify(boards.map(({ html, ...b }) => ({ ...b, bytes: html.length })), null, 1));
for (const b of boards) writeFileSync(`${out}/${b.id}.html`, b.html);
// Screenshots: neutralize the camera transform so each artboard is at 1:1, then clip to it.
await evaluate(`(() => { const cam = document.querySelector('.paper-camera'); cam.style.transform = 'none'; cam.style.scale = 'none'; cam.style.translate = 'none'; document.querySelectorAll('.paper-camera > :not([data-node-id])').forEach(e => e.style.display = 'none'); return getComputedStyle(cam).transform; })()`);
await sleep(500);
for (const b of boards) {
  const r = await evaluate(`(() => { const e = document.querySelector('.paper-camera > [data-node-id="${b.id}"]'); e.style.left = '0px'; e.style.top = '0px'; e.style.zIndex = 99999; const r = e.getBoundingClientRect(); return {x: r.x, y: r.y, width: r.width, height: r.height}; })()`);
    const shot = await send('Page.captureScreenshot', { format: 'png', clip: { ...r, scale: 2 * b.w / r.width }, captureBeyondViewport: true });
  if (shot.result?.data) writeFileSync(`${out}/${b.id}.png`, Buffer.from(shot.result.data, 'base64'));
  await evaluate(`(() => { const e = document.querySelector('.paper-camera > [data-node-id="${b.id}"]'); e.style.left = '-99999px'; return 1; })()`);
  console.log(b.id, b.w, b.h, JSON.stringify(r), shot.result?.data ? 'shot' : 'no shot ' + JSON.stringify(shot).slice(0, 200));
}
ws.close(); chrome.kill();

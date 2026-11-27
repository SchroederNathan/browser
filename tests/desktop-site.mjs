import assert from 'node:assert/strict';
import { readFileSync, mkdtempSync, writeFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

const requests = [];
const server = Bun.serve({
  hostname: '127.0.0.1', port: 0,
  fetch(request) {
    const path = new URL(request.url).pathname;
    if (!['/first', '/second', '/other'].includes(path)) return new Response(null, { status: 404 });
    const agent = request.headers.get('user-agent') ?? '';
    const mode = agent.includes('Macintosh') && !agent.includes('Mobile/') ? 'desktop'
      : agent.includes('Mobile/') ? 'mobile' : 'unknown';
    requests.push(`${path} ${mode}`);
    return new Response(`<title>${path} ${mode}</title>`, {
      headers: { 'Content-Type': 'text/html', 'Cache-Control': 'no-store' },
    });
  },
});

const directory = mkdtempSync(join(tmpdir(), 'desktop-site-'));
try {
  const file = join(directory, 'desktop.test.contract');
  const template = readFileSync(new URL('./desktop-site.contract-test', import.meta.url), 'utf8');
  writeFileSync(file, template.replaceAll('FIXTURE_ORIGIN', server.url.origin));
  const run = Bun.spawn(['bun', 'exact.mjs', 'test', 'ios', file, ...process.argv.slice(2)], {
    stdout: 'inherit', stderr: 'inherit',
  });
  assert.equal(await run.exited, 0, `iOS page-menu test; received ${requests.join(', ')}`);
  assert.deepEqual(requests, ['/first mobile', '/second mobile', '/second desktop', '/other mobile', '/second mobile']);
} finally {
  server.stop(true);
  rmSync(directory, { recursive: true, force: true });
}

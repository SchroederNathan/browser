import { readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const dir = process.argv[2];
if (!dir) throw Error('usage: bun .ci/eas-credentials.mjs <dir holding credentials.json>');

const file = join(dir, 'credentials.json');
const text = readFileSync(file, 'utf8');
let credentials;
try {
  credentials = JSON.parse(text);
} catch {
  // The parser's message can quote the input, which holds the certificate password.
  throw Error(`${file} is not EAS buildCredentials JSON`);
}
const targets = Object.entries(credentials ?? {});
if (targets.length !== 1) {
  throw Error(`expected exactly one iOS target in EAS buildCredentials, found ${targets.length}`);
}
const [target, { provisioningProfileBase64, distributionCertificate }] = targets[0];
const { dataBase64, password } = distributionCertificate ?? {};
for (const [name, value] of [['provisioningProfileBase64', provisioningProfileBase64], ['distributionCertificate.dataBase64', dataBase64], ['distributionCertificate.password', password]]) {
  if (typeof value !== 'string') throw Error(`EAS buildCredentials target ${target} has no ${name}`);
}

const write = (name, data) => writeFileSync(join(dir, name), data, { mode: 0o600 });
write('dist.p12', Buffer.from(dataBase64, 'base64'));
write('app.mobileprovision', Buffer.from(provisioningProfileBase64, 'base64'));
write('p12-password', password);
console.error(`EAS credentials for target ${target} written to ${dir}`);

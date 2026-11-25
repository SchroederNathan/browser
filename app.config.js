module.exports = {
  name: 'Exact Browser',
  slug: 'browser',
  owner: 'exponathan',
  version: process.env.EXACT_VERSION || '1.0.0',
  ios: {
    bundleIdentifier: 'com.nate.exactbrowser',
    infoPlist: { ITSAppUsesNonExemptEncryption: false },
  },
  extra: { eas: { projectId: 'e8248b92-6d6f-468b-8d22-529efaa96f1c' } },
};

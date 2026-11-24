module.exports = {
  name: 'Exact Browser',
  slug: 'exact-browser',
  owner: 'exponathan',
  version: process.env.EXACT_VERSION || '1.0.0',
  ios: { bundleIdentifier: 'com.exponathan.exactbrowser' },
  extra: { eas: { projectId: 'fad00826-e86b-4ab6-a075-10d8dc688291' } },
};

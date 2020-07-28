var customLaunchers = {
  // sl_chrome_latest: {
  //   base: 'SauceLabs',
  //   browserName: 'chrome'
  // },
  sl_firefox_latest: {
    base: 'SauceLabs',
    browserName: 'Firefox'
  },
  // sl_ie_latest: {
  //   base: 'SauceLabs',
  //   browserName: 'Internet Explorer'
  // },
  // sl_ie: {
  //   base: 'SauceLabs',
  //   browserName: 'Internet Explorer',
  //   version: '10'
  // },
  // sl_safari_latest: {
  //   base: 'SauceLabs',
  //   browserName: 'Safari'
  // },
  // sl_edge_latest: {
  //   base: 'SauceLabs',
  //   browserName: 'Microsoftedge'
  // },
  // sl_android_latest: {
  //   base: 'SauceLabs',
  //   browserName: 'Browser',
  //   platform: 'Android',
  //   deviceName: 'Android Emulator'
  // },
  // sl_ios_safari_latest: {
  //   base: 'SauceLabs',
  //   browserName: 'iphone',
  //   platform: 'OS X 10.9'
  // },
  // bs_opera_latest: {
  //   base: 'BrowserStack',
  //   browser: 'opera',
  //   os: 'Windows',
  //   os_version: '8'
  // },
};

module.exports = function(config) {
  return config.set({
    basePath: '',
    frameworks: ['jasmine'],
    sauceLabs: {
      testName: 'Referentiel',
      public: 'public'
    },
    browserStack: {
      username: process.env.BROWSER_STACK_USERNAME,
      accessKey: process.env.BROWSER_STACK_ACCESS_KEY,
      startTunnel: true,
      video: false,
      project: 'Referentiel'
    },
    files: [
      'dist/referentiel.js',
      'node_modules/reset-css/reset.css',
      'node_modules/jquery/dist/jquery.js',
      {
        pattern: 'test/**/*.js',
        included: true
      },
      {
        pattern: 'test/**/*.html',
        served: true,
        included: false
      }
    ],
    reporters: ['dots', 'saucelabs'],
    logLevel: config.LOG_INFO,
    autoWatch: true,
    // browsers: [ 'Chrome', 'Firefox' ]
    browsers: process.env.TRAVIS_BRANCH == 'master' ? Object.keys(customLaunchers) : ['Chrome', 'Firefox'],
    singleRun: process.env.CI == null ? false : true,
    port: 9876,
    colors: true,
    customLaunchers: customLaunchers,
    concurrency: 2
  });
};

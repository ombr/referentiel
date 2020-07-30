var customLaunchers = {
  // sl_chrome_latest: {
  //   base: 'SauceLabs',
  //   browserName: 'chrome'
  // },
  // sl_firefox_latest: {
  //   base: 'SauceLabs',
  //   browserName: 'Firefox'
  // },
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
  bs_ie_11: {
    base: 'BrowserStack',
    browser: 'IE',
    browser_version: '11.0',
    os: 'Windows',
    os_version: '7'
  },
  bs_ie_10: {
    base: 'BrowserStack',
    browser: 'IE',
    browser_version: '10.0',
    os: 'Windows',
    os_version: '7'
  },
  bs_firefox_latest: {
    base: 'BrowserStack',
    browser: 'Firefox',
    os: 'Windows',
    os_version: '10'
  },
  bs_chrome_latest: {
    base: 'BrowserStack',
    browser: 'Chrome',
    os: 'Windows',
    os_version: '10'
  },
  bs_safari_latest: {
    base: 'BrowserStack',
    browser: 'Safari',
    os: 'OS X',
    os_version: 'Mojave'
  }
}

module.exports = function (config) {
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
    reporters: ['dots', 'saucelabs', 'BrowserStack'],
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: (process.env.TRAVIS_PULL_REQUEST === null && process.env.TRAVIS_BRANCH === 'master') ? Object.keys(customLaunchers) : ['ChromeHeadless', 'FirefoxHeadless'],
    // browsers: [],
    singleRun: (process.env.CI != null),
    port: 9876,
    colors: true,
    customLaunchers: customLaunchers,
    concurrency: 2
  })
}

customLaunchers = {
  sl_chrome:
    base: 'SauceLabs',
    browserName: 'chrome',
    version: '36'
  sl_chrome_latest:
    base: 'SauceLabs',
    browserName: 'chrome',
  sl_firefox_latest:
    base: 'SauceLabs',
    browserName: 'firefox',
  sl_firefox_16:
    base: 'SauceLabs',
    browserName: 'firefox',
    version: '16'
  sl_ie_latest:
    base: 'SauceLabs',
    browserName: 'Internet Explorer',
  sl_ie:
    base: 'SauceLabs',
    browserName: 'Internet Explorer',
    version: '10'
  sl_safari_latest:
    base: 'SauceLabs',
    browserName: 'Safari',
  sl_safari:
    base: 'SauceLabs',
    browserName: 'Safari',
    version: '9'
  sl_edge_latest:
    base: 'SauceLabs',
    browserName: 'Microsoftedge',
  sl_edge:
    base: 'SauceLabs',
    browserName: 'Microsoftedge',
    version: '13'
  sl_android_latest:
    base: 'SauceLabs',
    browserName: 'Browser',
    platform: 'Android',
    deviceName: 'Android Emulator',
  sl_android:
    base: 'SauceLabs',
    browserName: 'Browser',
    platform: 'Android',
    version: '5.0',
    deviceName: 'Android Emulator',
  sl_ios_safari_latest:
    base: 'SauceLabs',
    browserName: 'iphone',
    platform: 'OS X 10.9',
  sl_ios_safari:
    base: 'SauceLabs',
    browserName: 'iphone',
    platform: 'OS X 10.9',
    version: '9.0'
  bs_opera_latest:
    base: 'BrowserStack',
    browser: 'opera',
    os: 'Windows',
    os_version: '8',
  bs_opera:
    base: 'BrowserStack',
    browser: 'opera',
    os: 'Windows',
    os_version: '8',
    browser_version: '23'
  # bs_chrome_windows:
  #   base: 'BrowserStack',
  #   os: 'Windows',
  #   os_version: '10',
  #   browser: 'chrome',
  #   browser_version: '47.0'
  # bs_firefox_windows:
  #   base: 'BrowserStack',
  #   os: 'Windows',
  #   os_version: '10',
  #   browser: 'firefox',
  # bs_firefox_mac:
  #   base: 'BrowserStack',
  #   browser: 'firefox',
  #   browser_version: '21.0',
  #   os: 'OS X',
  #   os_version: 'Mountain Lion'
  # bs_iphone5:
  #   base: 'BrowserStack',
  #   device: 'iPhone 5',
  #   os: 'ios',
  #   os_version: '6.0'
}


module.exports = (config) ->
  config.set
    basePath: '',
    frameworks: ['jasmine']

    sauceLabs:
      testName: 'Referentiel'
      public: 'public'
    browserStack:
      username: process.env.BROWSER_STACK_USERNAME,
      accessKey: process.env.BROWSER_STACK_ACCESS_KEY,
      startTunnel: true
      video: false
      project: 'Referentiel'

    files: [
      'dist/referentiel.js',
      'node_modules/reset-css/reset.css',
      'node_modules/jquery/dist/jquery.js',
      { pattern: 'test/**/*.coffee', included: true }
    ]

    preprocessors: {
      '**/*.coffee': ['coffee']
    }
    #
    reporters: ['dots', 'saucelabs']

    # level of logging
    # possible values:
    # - config.LOG_DISABLE
    # - config.LOG_ERROR
    # - config.LOG_WARN
    # - config.LOG_INFO
    # - config.LOG_DEBUG
    logLevel: config.LOG_INFO

    autoWatch: false

    # browsers: [ 'Chrome', 'Firefox' ]
    browsers: Object.keys(customLaunchers)

    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: true
    port: 9876
    colors: true

    customLaunchers: customLaunchers

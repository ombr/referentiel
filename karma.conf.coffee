module.exports = (config) ->
  config.set
    basePath: '',
    frameworks: ['jasmine']

    # plugins: [
    #   'karma-jasmine',
    #   'karma-browserstack-launcher'
    #   'karma-coffee-preprocessor'
    # ],
    browserStack: {
      username: process.env.BROWSER_STACK_USERNAME,
      accessKey: process.env.BROWSER_STACK_ACCESS_KEY,
      startTunnel: true
      video: false
      project: 'Referentiel'
    },

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
    reporters: ['progress', 'BrowserStack']

    # level of logging
    # possible values:
    # - config.LOG_DISABLE
    # - config.LOG_ERROR
    # - config.LOG_WARN
    # - config.LOG_INFO
    # - config.LOG_DEBUG
    logLevel: config.LOG_INFO

    autoWatch: false

    browsers: [
      # 'Chrome',
      # 'Firefox'
      'bs_firefox_windows',
      'bs_chrome_windows'
    ]

    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: true
    port: 9876
    colors: true

    customLaunchers:
      bs_chrome_windows:
        base: 'BrowserStack',
        os: 'Windows',
        os_version: '10',
        browser: 'chrome',
        browser_version: '47.0'
      bs_firefox_windows:
        base: 'BrowserStack',
        os: 'Windows',
        os_version: '10',
        browser: 'firefox',
      bs_firefox_mac:
        base: 'BrowserStack',
        browser: 'firefox',
        browser_version: '21.0',
        os: 'OS X',
        os_version: 'Mountain Lion'
      bs_iphone5:
        base: 'BrowserStack',
        device: 'iPhone 5',
        os: 'ios',
        os_version: '6.0'

module.exports = (config) ->
  config.set
    frameworks: ['jasmine']

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
    reporters: ['progress']



    # level of logging
    # possible values:
    # - config.LOG_DISABLE
    # - config.LOG_ERROR
    # - config.LOG_WARN
    # - config.LOG_INFO
    # - config.LOG_DEBUG
    logLevel: config.LOG_INFO

    autoWatch: true


    browsers: [
      'Chrome',
      'Firefox'
    ]

    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: false

const path = require('path');
const webpack = require('webpack');

module.exports = {
  entry: {
    'Referentiel': './src/referentiel.coffee',
  },
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: [ 'coffee-loader' ]
      }
    ]
  },
  output: {
    filename: 'referentiel.js',
    path: path.resolve(__dirname, 'dist'),
    library: '[name]',
    libraryTarget: 'umd'
  },
  plugins: [
    new webpack.optimize.UglifyJsPlugin()
  ]
};

const path = require('path');
const webpack = require('webpack');

module.exports = {
  mode: 'production',
  entry: './src/referentiel.js',
  devtool: 'none',
  output: {
    path: path.resolve(__dirname, 'dist'),
    library: 'Referentiel',
    libraryTarget: 'umd',
    filename: 'referentiel.js'
  },
  optimization: {
    minimizer: []
  }
};

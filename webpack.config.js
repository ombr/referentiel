const path = require('path')

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
  module: {
    rules: [
      {
        test: /\.js$/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: [
              ['@babel/preset-env', { targets: { ie: '11' } }]
            ]
          }
        }
      }
    ]
  }
}

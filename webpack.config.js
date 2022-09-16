const path = require("path");

module.exports = {
  mode: "development",
  entry: "./dist/referentiel.js",
  output: {
    library: "Referentiel",
    path: path.resolve(__dirname, "dist"),
    filename: "referentiel.umd.js",
  },
  module: {},
};

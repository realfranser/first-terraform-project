"use strict";

var _express = _interopRequireDefault(require("express"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

var DEFAULT_PORT = 3000;
var app = (0, _express["default"])();
app.get("/", function (req, res) {
  res.send("Hello there!");
});
app.listen(DEFAULT_PORT, function () {
  console.log("Exaple app listening on port ".concat(DEFAULT_PORT));
});
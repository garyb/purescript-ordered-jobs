"use strict";

var gulp = require("gulp");
var plumber = require("gulp-plumber");
var purescript = require("gulp-purescript");
var run = require("gulp-run");

var paths = [
  "src/**/*.purs",
  "bower_components/purescript-*/src/**/*.purs"
];

gulp.task("default", function() {
  return gulp.src(paths.concat(["test/Main.purs"]))
    .pipe(plumber())
    .pipe(purescript.psc({ main: "Test.Main" }))
    .pipe(run("node"));
});

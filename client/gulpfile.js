const gulp = require('gulp');
const concat = require('gulp-concat');

function defaultTask(cb) {
    gulp
        .src([
            'js/common.js',
            'js/localstorage.js',
            'js/network.js',
            'js/rest.js',
            'js/socket.js',
            'js/telegram.js',
            'js/telemetree.js', 
            'js/ton.js',
            'game.js',
        ])
        .pipe(concat('bundle.js'))
        .pipe(gulp.dest('prod/yandex'));
    cb();
}
  
exports.default = defaultTask
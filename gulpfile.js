/** 
 * Make sure Graphicsmagick is installed on your system
 * osx: brew install graphicsmagick
 * ubuntu: apt-get install graphicsmagick
 * 
 * Install these gulp plugins
 * gulp, gulp-image-resize, gulp-imagemin and imagemin-pngquant
 * 
 * Group images according to their output dimensions. 
 * (ex: place all portfolio images into "images/portfolio"
 * and all background images into "images/bg")
 * 
 **/
 
// require gulp plugins 
var gulp = require('gulp');
var imageresize = require('gulp-image-resize');
var imagemin = require('gulp-imagemin');
var rename = require('gulp-rename');
var newy = require('gulp-newy');
var concat = require('gulp-concat');
var path = require('path');
var uglify = require('gulp-uglify');
var pump = require('pump');
var jslint = require('gulp-jslint');
var iptc = require('node-iptc');
var transform = require('gulp-transform');
var parser = require('exif-parser');

var imageminJpegOptim = require('imagemin-jpegoptim');

// set the folder name and the relative paths
// in the example the images are in ./assets/images
// and the public directory is ../public
var paths = {
    src: './photos/',
    dest: './source/photos/',
    pages: './source/pages/'
}

var originalSize = 1920;
var originalPosterSize = 576;

var sizes = [ 1920, 960, 720, 576, 420, 288, 144 ];
var posterSizes = [ 576, 288 ];

var qualitySettings = { 1920: 0.75,
					    960: 0.8,
					    720: 0.8,
					    576: 0.85,
					    420: 0.9,
					    288: 0.95,
					    144: 0.95 };
					    
var aspectRatios = { 
  '1920x1280': '32',
  '1920x1440': '43',
  '1280x1920': '23',
  '1440x1920': '34'
};					

var useImageMagick = true;

// images gulp task

gulp.task('resize-photos', function () {
  sizes.forEach(function(size) {
    var percentage = (100 * size) / originalSize;
    gulp  
      .src(paths.src+'/**/*.jpg')
      .pipe(newy(function(projectDir, srcFile, absSrcFile) {
    	var destinationFile = path.join(projectDir, 
    									paths.dest, 
    									absSrcFile.substr(projectDir.length + paths.src.length - 1))
    	  .replace(".jpg","-" + size + ".jpg");
    	return destinationFile;
      }))
	  .pipe(imageresize({ percentage: percentage, quality: qualitySettings[size], imageMagick: useImageMagick } ))
	  .pipe(imagemin([ imageminJpegOptim() ], { verbose: true } ))
	  .pipe(rename({ suffix: "-" + size }))
	  .pipe(gulp.dest(paths.dest));
  });
});

function createPageData(contents) {
	let iptc_data = iptc(contents);
	let title = iptc_data.object_name.replace(/\"/g,'\\"');
	let caption = iptc_data.caption.replace(/\"/g,'\\"');
	let locationComponents = [iptc_data.country_or_primary_location_name];
	if (iptc_data.province_or_state) {
		locationComponents.unshift(iptc_data.province_or_state);
	}
	if (iptc_data.city) {
		locationComponents.unshift(iptc_data.city);
	}
	else {
		if (iptc_data.sub_location) {
			locationComponents.unshift(iptc_data.sub_location);
		}
	}
	let location = locationComponents.join(", ");
	let date = iptc_data.date_created.substring(0,4) + "-" + 
			   iptc_data.date_created.substring(4,6) + "-" + 
			   iptc_data.date_created.substring(6,8);
	let tags = iptc_data.keywords.join(",");
	
	var parserInstance = parser.create(contents);
	var exif = parserInstance.parse();
	var dimensions = `${exif.imageSize.width}x${exif.imageSize.height}` 
	var ratio = aspectRatios[dimensions];
	if (ratio == undefined) {
	  console.log(`Unrecognized aspect ratio ${dimensions} for image '${title}'`);
	  ratio = "43";
	} 
	return `---
title: "${title}"
caption: "${caption}"
location: ${location}
date: ${date}
tags: ${tags}
aspectratio: ${ratio}
---
`;
};


gulp.task('create-pages', function() {
  gulp
    .src(paths.src+'/**/*.jpg')
    .pipe(newy(function(projectDir, srcFile, absSrcFile) {
    	var destinationFile = path.join(projectDir, 
    									paths.pages, 
    									absSrcFile.substr(projectDir.length + paths.src.length - 1))
    	  .replace(".jpg",".html.markdown");
    	return destinationFile;
    }))
    .pipe(transform(createPageData))
    .pipe(rename({ extname: ".html.markdown" }))
    .pipe(gulp.dest(paths.pages));
});

gulp.task('resize', ['resize-photos'] );

gulp.task('compile-javascript', function() {
  return gulp.src('./source/js/plugins/*.js')
    .pipe(concat('plugins.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./source/js/'));
});

gulp.task('check-javascript', function () {
  return gulp.src('./source/js/plugins/*.js')
    .pipe(jslint({}))
    .pipe(jslint.reporter('default'));
});

gulp.task('default',['compile-javascript']);



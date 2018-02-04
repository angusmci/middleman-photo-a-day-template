# middleman-photo-a-day-template

## Overview

This is a project template for implementing a simple photo-a-day blog site using the [Middleman](http://middlemanapp.com/) static site generator. For more information about project templates, see the 
[Middleman project template documentation](https://middlemanapp.com/advanced/project-templates/).

'Photo a day' projects are popular with amateur and not-so-amateur photographers: the idea is to challenge yourself to take a photograph every day for an entire year. The other terms are up to you: you could take only photographs on a particular theme, or using particular techniques, or particular equipment. The only hard and fast rule is: one photo a day, every day.

This template lets you create a simple static blog site to show your pictures. Each picture gets its own page. There are also automatically-computed month and tag indexes.

Note that the assumption that the site will show exactly one year's worth of pictures is built into the framework. You won't be able to use this template to showcase pictures from multiple years without making some changes to the code.

## Installation

... installation notes will go here; in the meantime, refer to the Middleman documentation ...

## Configuration

All the basic configuration required can be made in `config.rb`. The first block of variable declarations in the file are used to set up all the information about your site. You can make changes to individual pages or stylesheets if you like -- and you'll probably want to change the content in the `about` and `info` sections -- but you should be able to set up the configuration variables and have a usable site (almost) immediately.

## Photos

Photographs go in the `photos` directory in the root of the project. Each photo is named by date, e.g. `2018-01-01.jpg`.

The tools provided with the project take care of generating pages from the photographs, and of resizing the photographs for different device sizes. You need to provide an appropriately sized master picture, which has been labeled and tagged using an [IPTC metadata](https://iptc.org/standards/photo-metadata/) editor. The tools will read this metadata to generate your pages.

The tools assume that the longest dimension of the master photo will be 1920 pixels in length, and the aspect ratio of the picture will be one of 3:2, 2:3, 4:3 or 3:4. If you want to display panoramas or square pictures, you'll need to make some changes to the code. Sorry.	
	
The tools also assume that each picture will have metadata that specifies the title, a description, a date, and some tags. Lots of graphics or photo editing software contains tools to allow you to edit this metadata. For example, I use Adobe Lightroom for managing my photos, which comes with built-in tools for titling, captioning and tagging pictures. Other software has similar capabilities.

When you have prepared the photographs, you can generate the page files and photos using `gulp`:

	gulp resize
	gulp create-pages
	
Once you've done that, you can just launch Middleman as you would normally, i.e.

	bundle exec middleman server
	
and everything should just work.

You'll need to repeat the `resize` and `create-pages` steps each time you add a new photograph. They generally run very quickly, however, so that shouldn't be a problem (and they use the `newy` gulp plugin to avoid doing any unnecessary work).

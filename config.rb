###
# Page options, layouts, aliases and proxies
###

# Configuration

config[:sitename] = "Name of This Site"									# Title of site
config[:siteshortname] = "1999"											# Short name of site
config[:siteslug] = "Subtitle of This Site"								# Short description of site
config[:siteurl] = "http://example.com"									# URL of site
config[:siteauthorname] = "A.N. Author" 								# Name of site author
config[:siteauthorurl] = "http://example.com/author/"					# URL of site author's homepage
config[:siteauthorlocale] = "City, State, Country" 						# Physical location of author
config[:sitetwitter] = "yourtwitterhandle"								# Twitter handle of author
config[:siteyear] = "1999"												# Year of site
config[:googleanalyticscode] = "UA-0000000-0"							# Google Analytics code
config[:extendedlicenseurl] = "/info/licensing/"						# URL of extended license page
config[:copyrightname] = "A.N. Author"									# Name of copyright holder
config[:copyrighturl] = "/info/copyright/"								# URL of copyright page
config[:copyrightyear] = "1999-2018"									# Years of copyright validity
config[:timezone] = "-05:00"											# Timezone of site author
config[:homepagestyle] = "thumbs"										# Set to 'thumbs' or 'photo'
config[:downloadprefix] = "myphotosite"									# Prefix for downloaded files

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

require "lib/page_helpers"
helpers Page_Helpers

activate :directory_indexes

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  blog.permalink = "/{month}/{day}/index.html"
  # Matcher for blog source files
  blog.sources = "pages/{year}-{month}-{day}.html"
  blog.taglink = "tags/{tag}/index.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  blog.month_link = "/{month}/index.html"
  # blog.day_link = "/{month}/{day}/index.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "layouts_blog/tag.html"
  blog.month_template = "layouts_blog/calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

page "/pages/*", :layout => "photo"

page "/feed.xml", layout: false
# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # Minify CSS on build
  activate :minify_css
	
  # Minify Javascript on build
  activate :minify_javascript
  
  # Minify HTML
  activate :minify_html  
  
  ignore "layouts_blog/*"
  
  activate :external_pipeline,
     name: :gulp,
     command: "gulp compress-icons",
     source: "tmp",
     latency: 1
  
end

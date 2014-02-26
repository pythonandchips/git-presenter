# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "git_presenter"
  gem.homepage = "http://github.com/pythonandchips/git-presenter"
  gem.license = "MIT"
  gem.summary = %Q{Code presentation tool using git}
  gem.description = %Q{Code presentation tool using git}
  gem.email = "pythonandchips@gmail.com"
  gem.authors = ["Colin Gemmell"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

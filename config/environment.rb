ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
require 'rubygems'
require 'uri'
require 'pathname'
require 'sinatra'
require "sinatra/reloader" if development?
require 'redis'

$redis = Redis.new(:host => 'localhost', :port => 6379)

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
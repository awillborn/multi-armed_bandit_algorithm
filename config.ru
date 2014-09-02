# Require config/environment.rb
require ::File.expand_path('../config/environment',  __FILE__)

set :app_file, __FILE__

configure do
  set :views, File.join(Sinatra::Application.root, "app", "views")
  require 'redis'
  uri = URI.parse(ENV["REDISCLOUD_URL"])
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

run Sinatra::Application

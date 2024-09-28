shared_path = File.expand_path("../..", __FILE__)

environment ENV['RAILS_ENV'] || 'development'

pidfile "#{shared_path}/tmp/pids/puma.pid"
state_path "#{shared_path}/tmp/pids/puma.state"
stdout_redirect "#{shared_path}/log/puma_access.log", "#{shared_path}/log/puma_error.log", true

bind "unix://#{shared_path}/tmp/sockets/puma.sock"

libdir = File.dirname(__FILE__)+"/lib"
$: << libdir
confdir = File.dirname(__FILE__)+"/config"
$: << confdir

ENV["RUBYGAME_NOINIT"]="1"
require 'environment'
require 'gamebox/tasks/gamebox_tasks'
STATS_DIRECTORIES = [
  %w(Source            src/), 
  %w(Config            config/), 
  %w(Maps              maps/), 
  %w(Unit\ tests       specs/),
  %w(Libraries         lib/),
].collect { |name, dir| [ name, "#{APP_ROOT}/#{dir}" ] }.select { |name, dir| File.directory?(dir) }


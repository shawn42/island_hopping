libdir = File.dirname(__FILE__)+"/lib"
$: << libdir
confdir = File.dirname(__FILE__)+"/config"
$: << confdir

ENV["RUBYGAME_NOINIT"]="1"
require 'environment'
require 'gamebox/tasks/gamebox_tasks'
puts APP_ROOT
STATS_DIRECTORIES = [
  %w(Source            src/), 
  %w(Config            config/), 
  %w(Maps              maps/), 
  %w(Unit\ tests       specs/),
  %w(Libraries         lib/),
].collect { |name, dir| [ name, "#{dir}" ] }.select { |name, dir| File.directory?(dir) }
desc "Report code statistics (KLOCs, etc) from the application"
task :stats do
  require 'code_statistics'
  CodeStatistics.new(*STATS_DIRECTORIES).to_s
end


namespace :dist do
  task :vendor do
    sh 'wget http://github.com/downloads/shawn42/gamebox/vendor.zip; unzip vendor.zip; rm vendor.zip'
  end
  task :win do
    # create dist dir
    FileUtils.mkdir "dist" unless File.exist? "dist"
    # pull down windows app shell
    # expand into place
    sh 'cd dist; wget http://github.com/downloads/shawn42/gamebox/gamebox_app.zip; unzip gamebox_app.zip; mv gamebox_app/* .; rm gamebox_app.zip; rm -rf gamebox_app'

    # copy config/src/lib/data into dist/src
    %w{vendor config data }.each do |dir|
      FileUtils.cp_r dir, File.join('dist','src', dir) if File.exist? dir
    end
    FileUtils.cp_r 'src', File.join('dist', 'src')

    # create zip of dist?
  end
end

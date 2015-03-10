require "bundler/gem_tasks"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'lib/*.rb']
end

require "rake/extensiontask"
Rake::ExtensionTask.new "reversi" do |ext|
  ext.lib_dir = "lib/reversi"
end

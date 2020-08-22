require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :data do
  desc "Compile an Emoji Spec into the flattened YML"
  task :load_spec do
    require 'development/emoji_yaml_parsr'
    EmojiYamlParsr.update_data
  end
end

namespace :scrape do

  desc "Pull down all emoji into YML files (long execution: 3-4 hours)"
  task :all do
    require 'development/emoji_scrapr'
    destination_dir = '/tmp/'
    scrapr = EmojiScrapr.new
    duration = scrapr.scrape_all
  ensure
    puts "Done! #{duration} secs"
    puts "Saved to: " + scrapr.save
  end
end
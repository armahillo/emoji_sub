require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

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

  def harvest(destination = DUMP_PATH)
    @categories.each do |section, url|
      @all_emoji[section] = collect_emoji_list(url)
      dump_to_yaml(section + '_urls', scrapr.all_emoji.fetch(section,[]))
      collect_all_emoji(section)
      dump_to_yaml(section, scrapr.all_emoji.fetch(section,[]))
    end
  end

  def collect_all_emoji(section , delay = 2)
    
    scrape_all_emoji_in_category(@all_emoji[section], delay)
  end
end
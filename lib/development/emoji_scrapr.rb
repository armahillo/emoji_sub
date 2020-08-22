=begin
urls = { 'people' => '/people/', 'nature' => '/nature/', 
  'food-drink' => '/food-drink/', 'activity' => '/activity/', 
  'travel-places' => '/travel-places/', 'objects' => '/objects/',
  'symbols' => '/symbols/', 'flags' => '/flags/' }
=end

require 'mechanize'
#require 'pry'
#require 'binding_of_caller'

class EmojiScrapr
  BASE_URL = "https://emojipedia.org"
  DUMP_PATH = File.dirname(File.expand_path(__FILE__)) + "../data/"

  attr_reader :all_emoji, :categories

  def initialize
    @agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    @all_emoji = {}
    @categories = {}
  end

  def harvest(destination = DUMP_PATH)
    @categories.each do |section, url|
      @all_emoji[section] = collect_emoji_list(url)
      dump(section + '_urls', scrapr.all_emoji.fetch(section,[]))
      collect_all_emoji(section)
      dump(section, scrapr.all_emoji.fetch(section,[]))
    end
  end

  def collect_emoji_list(url)
    emoji_collection = {}
    @agent.get(BASE_URL + url) do |page|
      emoji_list = page.search("//ul[@class='emoji-list']/li/a")
      emoji_list.each do |link|
        emoji_url = link.attributes["href"].value
        emoji_collection[link.text] = { url: emoji_url }
      end
    end
    emoji_collection
  end

  def collect_all_emoji(section , delay = 2)
    puts "\nScraping #{section} (#{@all_emoji[section].keys.size})"
    @all_emoji[section].transform_values! do |data|
      result = scrape_emoji_page(data[:url])
      sleep(delay)
      print "😀"
      data.merge!(result)
    end
  end

  def collect_categories
    @agent.get(BASE_URL + url) do |page|
      category_list = page.search("//ul[@id='nav-categories']/li/a")
      emoji_list.each do |link|
        category_url = BASE_URL + link.attributes["href"].value
        @categories[link.text] = category_url
        @all_emoji[section] ||= {}
      end
    end
  end

  def scrape_emoji_page(url)
    url = BASE_URL + url unless url.start_with?('http')
    body = @agent.get(url).body
    { unicode: body.scan(/U\+[\w\d]{4,6}/),
      shortcodes: body.scan(/\:[\w\_\-\d]+:/) }
  end

  private
  
  def dump(filename, data)
    File.open("#{filename}.yml",'w') do |f|
      f.write data.to_yaml
    end
  end
end

#scrapr = EmojiScrapr.new




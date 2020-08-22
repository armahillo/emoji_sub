require 'mechanize'

class EmojiScrapr
  BASE_URL = "https://emojipedia.org"
  DUMP_PATH = File.dirname(File.expand_path(__FILE__)) + "../data/"

  attr_reader :all_emoji

  def initialize
    @agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    @all_emoji = {}
  end

  def save(location = '/tmp/')
    filename = "scrape-#{Time.now.to_i}"
    dump_to_yaml(location + filename, @all_emoji)
    filename
  end

  def scrape_all
    start = Time.now.to_i
    categories = scrape_categories_page
    categories.each do |category, category_url|
      scrape_category_page!(category, category_url)
      puts "\nScraping #{category} (#{@all_emoji[category].keys.size})"
      scrape_all_emoji_in_category!(category)
    end
    Time.now.to_i - start
  end

  ##
  # scrape_all_emoji_in_category(category: array, [delay]:integer)
  # Accepts an hash of hashes to fill out (keyed on description)
  # Returns the same hash, but with the values filled out
  ##
  def scrape_all_emoji_in_category(category_hash, delay = 2)
    category_hash.transform_values! do |data|
      result = scrape_emoji_page(data[:url])
      sleep(delay)
      print "😀"
      data.merge!(result)
    end
  end

  ##
  # scrape_all_emoji_in_category!(category, delay [2])
  # As above, but using local ivar
  ##
  def scrape_all_emoji_in_category!(category, delay = 2)
     scrape_all_emoji_in_category(@all_emoji[category], delay)
  end

  ##
  # scrape_category_page(category_url: string)
  # Accepts a url string (full or partial)
  # Returns a hash of all emoji descriptions & urls on the page
  ##
  def scrape_category_page(category_url)
    emoji_collection = {}
    @agent.get(clean_url(category_url)) do |page|
      emoji_list = page.search("//ul[@class='emoji-list']/li/a")
      emoji_list.each do |link|
        emoji_url = link.attributes["href"].value
        emoji_collection[link.text] = { url: emoji_url }
      end
    end
    emoji_collection
  end

  ##
  # scrape_category_page!(category: string, category_url: string)
  # As above, but persists to local ivar
  ##
  def scrape_category_page!(category, category_url)
    @all_emoji[category] = scrape_category_page(category_url)
  end

  ##
  # scrape_categories_page
  # Returns the categories from the homepage
  ##
  def scrape_categories_page
    categories = {}
    # On non-root pages, the xpath is:
    # "//ul[@id='nav-categories']/li/a"
    @agent.get(clean_url('/')) do |page|
      page.search("//h2[text()='Categories']/following-sibling::ul/li/a").each do |link|
        category_url = link.attributes["href"].value
        categories[link.text.gsub(/[^\w\s]+/,'').lstrip] = category_url
      end
    end

    categories
  end

  ##
  # scrape_emoji_page (url: string)
  # Accepts a URL (full or partial)
  # Returns a hash of unicodes and shortcodes
  ##
  def scrape_emoji_page(url)
    body = @agent.get(clean_url(url)).body
    { unicode: body.scan(/U\+[\w\d]{4,6}/),
      shortcodes: body.scan(/\:[\w\_\-\d]+:/) }
  end

  private
  
  def dump_to_yaml(filename, data)
    File.open("#{filename}.yml",'w') do |f|
      f.write data.to_yaml
    end
  end

  def clean_url(url)
    BASE_URL + url unless url.start_with?('http')
  end
end


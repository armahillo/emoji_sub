require "emoji_sub/version"
require 'yaml'

module EmojiSub
  EMOJI_MAPPING_YAML = "data/emoji.yaml"
  
  def emoji_sub(text, additional_mappings = {})
    known_emoji = YAML.load(File.read(EMOJI_MAPPING_YAML)).merge(additional_mappings)

    discovered_emoji = text.scan(/:([\w\d\-\_]+):/).flatten.map(&:to_sym).uniq
    found = discovered_emoji.each_with_object({}) do |emoji, found|
      found[emoji] = known_emoji.fetch(emoji,nil)
    end.compact

    found.each do |shortcode, unicode|
      text.gsub!(/:#{shortcode}:/, "&#x#{unicode}")
    end
    
    text
  end
  module_function :emoji_sub


end
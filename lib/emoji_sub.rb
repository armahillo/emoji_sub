require "emoji_sub/version"
require 'yaml'

module EmojiSub
  EMOJI_MAPPING_YAML = "data/emoji.yaml"
  
  def emoji_sub(text, additional_mappings = {})
    known_emoji = emoji_definitions.merge(additional_mappings)

    discovered_emoji = text.scan(/:([\w\d\-\_]+):/).flatten.map(&:to_sym).uniq
    found = discovered_emoji.each_with_object({}) do |emoji, found|
      found[emoji] = known_emoji.fetch(emoji,nil)
    end.compact

    found.each do |shortcode, unicode|
      text.gsub!(/:#{shortcode}:/, Array(unicode).map { |u| "&#x#{u}" }.join(''))
    end
    
    text
  end

  def emoji_definitions
    m = YAML.load(File.read(EMOJI_MAPPING_YAML)).values
    @emoji_definitions ||= m.inject({}) { |a,memo| memo.merge(a) }
    
    #@emoji_definitions ||= m.collect(&:values).flatten
  end
  module_function :emoji_sub, :emoji_definitions

end
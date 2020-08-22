require "emoji_sub/version"
require 'YAML'

module EmojiSub
  EMOJI_MAPPING_YAML = "../../data/emoji.yaml"

  class Error < StandardError; end
  
  def emoji_sub(text)
    known_emoji = YAML.load(File.read(EMOJI_MAPPING_YAML))
    discovered_emoji = text.scan(/:([\w\d\-\_]+):/).flatten.map(&:to_sym).uniq
    found = discovered_emoji.each_with_object({}) do |emoji, found|
      found[emoji] = known_emoji.fetch(emoji,'')
    end

    found.each do |shortcode, unicode|
      text.gsub!(/:#{shortcode}:/, "&#x#{unicode}")
    end
    
    text
  end


end

#  TEXT = 'This is testing text :100: :100: :100: :bad_dude: It is great :slightly_smiling_face:.'
# p emoji_sub(TEXT)

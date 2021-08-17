module EmojiSub
  extend self
  def emoji_sub(text, additional_mappings = {})
    known_emoji = definitions.merge(additional_mappings)

    discovered_emoji = text.scan(/:([\w\d\-\_]+):/).flatten.map(&:to_sym).uniq
    found = discovered_emoji.each_with_object({}) do |emoji, found|
      found[emoji] = known_emoji.fetch(emoji,nil)
    end.compact

    found.each do |shortcode, unicode|
      text.gsub!(/:#{shortcode}:/, Array(unicode).map { |u| "&#x#{u}" }.join(''))
    end
    
    text
  end

  module_function :emoji_sub
end
module EmojiSub
  GEM_ROOT = File.dirname(__FILE__) + "/.."
  EMOJI_MAPPING_YAML = GEM_ROOT + "/data/emoji.yaml"
end

require_relative 'emoji_sub/version'
require_relative 'emoji_sub/definitions'
require_relative 'emoji_sub/emoji_sub'

require 'yaml'

module EmojiSub
  extend self
  def definitions
    @emoji_definitions ||= YAML.load(File.read(EMOJI_MAPPING_YAML))
  end

  module_function :definitions
end
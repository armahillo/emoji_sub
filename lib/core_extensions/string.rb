module CoreExtensions
  module EmojiSub
    ##
    # This monkey patches String so that it can receive emoji_sub directives
    # cf. https://github.com/armahillo/emoji_sub/issues/2
    # If you want to monkey patch your use of String, you should be able to include
    # this module and that should do it.
    ##
    module String
      def emoji_sub(options = {})
        ::EmojiSub.emoji_sub(self, options)
      end

      def emoji_sub!(options = {})
        replace emoji_sub(options)
      end
    end
  end
end
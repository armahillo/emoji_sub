require_relative 'lib/emoji_sub'

Gem::Specification.new do |spec|
  spec.name          = "emoji_sub"
  spec.version       = EmojiSub::VERSION
  spec.authors       = ["Aaron Hill"]
  spec.email         = ["armahillo@gmail.com"]

  spec.summary       = %q{Replace your Slack short_code emoji with unicode equivalents}
  spec.description   = %q{EmojiSub allows you to use :short_code_emoji: in your text and quickly replace it with the natural Unicode versions via a bit of string parsing logic}
  spec.homepage      = "https://github.com/armahillo/emoji_sub"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/armahillo/emoji_sub"
  spec.metadata["changelog_uri"] = "https://github.com/armahillo/emoji_sub/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|lib\/development)/}) }
  end
  spec.require_paths = ["lib"]

end



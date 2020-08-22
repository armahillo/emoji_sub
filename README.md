# EmojiSub

This gem is the byproduct of me editing a Markdown file for a static-site generator, wanting to use :heart: and have it show up like this: &#x2764;

OBVIOUSLY, the best way to solve this is to find a full list of all the slack-emoji shortcodes, find a separate list of all the actual emoji and their hex-unicode values, and then compile a mapping of those shortcodes to hex-unicodes. So enjoy the fruit of several hours of labor, here.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'emoji_sub'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install emoji_sub

## Usage

Currently, it's limited to direct calling (I've not monkey-patched `String`...yet). So if you had a body of text, like "I :heart: New York :statue_of_liberty: :pizza: :dancer:" and wanted it to look like this: 
"I &#x2764; New York &#x1F5FD; &#x1F355; &#x1F483;", you would do this:

```ruby
text = "I :heart: New York :statue_of_liberty: :pizza: :dancer:"
better_text = EmojiSub.emoji_sub(text)
```

You can even pass in additional mappings if you know about unicodes I forgot! (I'M SURE THERE ARE MORE, GOOD GOB THERE ARE SO MANY).

```ruby
additional_emoji = { pigeon: "1F426" } # Technically that's the unicode for birb, but...
text = "I :heart: New York :statue_of_liberty: :pizza: :pigeon:"
better_text = EmojiSub.emoji_sub(text, additional_emoji)
```

You can even, even override the mappings I did with your own! If your expert-moji opinion says that `:smiley_cat:` should be &#x1F638; and `:smile_cat:` should be &#x1F63A; who am I to disagree? They're very different, clearly, and obviously the "-y" on the end of "smile-y" means that the cat should have eyes that are more smiley. Very reasonable and I completely understand! YES I'M FINE WHY DO YOU ASK?

In all seriousness, one big reason I could see wanting to do overrides is because emoji shortcodes in Slack are often quite gendered, such as :man_bouncing_ball: => &#x26F9; and you'd like to use :woman_bouncing_ball: (&#x26F9;), which doesn't exist in the current YML mapping because GOOD GOB THERE ARE SO MANY AND I AM BUT ONE PERSON.

Currently, the emoji are also a single skin-tone. I'm still learning how to combine emoji to do skin-tone modifiers, but when I do, you would also use the overrides thing to do that, as well! If you're an e-moji e-xpert and can help out with this, please do!

Other reasons to override might be because you prefer a specific version of `:airplane:` to be mapped to `:airplane:` instead of &#x2708;, and at the end of the day, this is about making it more convenient for you.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/armahillo/emoji_sub. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/armahillo/emoji_sub/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EmojiSub project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/armahillo/emoji_sub/blob/master/CODE_OF_CONDUCT.md).
